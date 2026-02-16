package service

import (
	"context"
	"fmt"
	"log"
	"time"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/auth"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

const (
	MinInvoiceAmountUSD         = 200.0
	CollectionReservations      = "reservations"
	CollectionFinancialPending  = "financial_pending"
	CollectionUsedInvoices      = "used_invoices"
	CollectionUsers             = "users"
	CollectionStores            = "stores"
	CollectionSponsorshipLedger = "sponsorship_ledger" // Sub-coleção Multi-Sponsor
	CollectionUsedVouchers      = "used_vouchers"      // Anti-fraude offline
	CollectionBIEvents          = "bi_events"          // Inteligência de dados
)

// PaymentService implementa o serviço de patrocínio de lojas
type PaymentService struct {
	pb.UnimplementedPaymentServiceServer
	firestoreClient *firestore.Client
	fcmClient       *messaging.Client
	voucherService  *VoucherService // Serviço de geração de vouchers JWT
}

// NewPaymentService cria uma nova instância do PaymentService
func NewPaymentService(firestoreClient *firestore.Client, firebaseApp *firebase.App) (*PaymentService, error) {
	ctx := context.Background()
	fcmClient, err := firebaseApp.Messaging(ctx)
	if err != nil {
		log.Printf("Warning: FCM client not initialized: %v", err)
		// Continua sem FCM para não bloquear o serviço
	}

	// Inicializar serviço de vouchers JWT
	voucherService, err := NewVoucherService()
	if err != nil {
		log.Printf("Warning: VoucherService not initialized: %v", err)
		// Continua sem VoucherService - vouchers não serão gerados
	}

	return &PaymentService{
		firestoreClient: firestoreClient,
		fcmClient:       fcmClient,
		voucherService:  voucherService,
	}, nil
}

// ==================== RequestSponsorship ====================
// Loja patrocina o estacionamento do cliente após validar nota fiscal
// MULTI-SPONSOR: Permite múltiplas lojas patrocinarem a mesma reserva

func (s *PaymentService) RequestSponsorship(ctx context.Context, req *pb.SponsorshipRequest) (*pb.SponsorshipResponse, error) {
	// 1. RBAC: Apenas PARTNER_STORE pode executar
	claims, err := auth.RequireRole(ctx, auth.RolePartnerStore, auth.RoleAdmin)
	if err != nil {
		return nil, err
	}

	// 2. Validações básicas
	if req.GetReservationId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "reservation_id is required")
	}
	if req.GetInvoice() == nil {
		return nil, status.Errorf(codes.InvalidArgument, "invoice is required")
	}

	// 3. Validar valor mínimo da nota fiscal
	if req.GetInvoice().GetAmountUsd() < MinInvoiceAmountUSD {
		return &pb.SponsorshipResponse{
			Success:   false,
			Message:   fmt.Sprintf("Invoice amount $%.2f is below minimum $%.2f", req.GetInvoice().GetAmountUsd(), MinInvoiceAmountUSD),
			ErrorCode: "AMOUNT_INSUFFICIENT",
		}, nil
	}

	invoiceID := req.GetInvoice().GetInvoiceId()
	syncID := req.GetSyncId() // Para idempotência offline
	storeID := claims.PartnerID
	if storeID == "" {
		return nil, status.Errorf(codes.FailedPrecondition, "user not linked to any store")
	}
	storeName := claims.PartnerName
	if storeName == "" {
		storeName = req.GetInvoice().GetStoreName()
	}
	reservationID := req.GetReservationId()

	// Taxa de câmbio (placeholder - integrar API real em produção)
	exchangeRate := 5.0

	// Variáveis de resultado da transação
	var userId string
	var originalPrice float64
	var currentBalance float64
	var totalSponsored float64
	var newStatus pb.TicketStatus
	var garageId string
	var garageName string
	var vehiclePlate string
	var ledgerEntryID string
	var sponsorsSummary []SponsorClaim

	// 4. Transação atômica no Firestore
	err = s.firestoreClient.RunTransaction(ctx, func(ctx context.Context, tx *firestore.Transaction) error {
		// 4a. Verificar idempotência via sync_id (para offline)
		if syncID != "" {
			idempotencyRef := s.firestoreClient.Collection(CollectionReservations).
				Doc(reservationID).
				Collection(CollectionSponsorshipLedger).
				Where("sync_id", "==", syncID).
				Limit(1)
			existingDocs, err := idempotencyRef.Documents(ctx).GetAll()
			if err == nil && len(existingDocs) > 0 {
				// Já processado - retornar sucesso sem reprocessar
				return status.Errorf(codes.AlreadyExists, "sync_id %s already processed", syncID)
			}
		}

		// 4b. Verificar se invoice_id já foi usada (Anti-Fraude)
		invoiceKey := fmt.Sprintf("%s_%s", storeID, invoiceID)
		invoiceRef := s.firestoreClient.Collection(CollectionUsedInvoices).Doc(invoiceKey)
		invoiceDoc, err := tx.Get(invoiceRef)
		if err == nil && invoiceDoc.Exists() {
			return status.Errorf(codes.AlreadyExists, "invoice %s already used", invoiceID)
		}

		// 4c. Buscar reserva e verificar status
		reservationRef := s.firestoreClient.Collection(CollectionReservations).Doc(reservationID)
		reservationDoc, err := tx.Get(reservationRef)
		if err != nil {
			return status.Errorf(codes.NotFound, "reservation not found: %s", reservationID)
		}

		data := reservationDoc.Data()
		currentStatusInt := int32(0)
		if v, ok := data["ticket_status"].(int64); ok {
			currentStatusInt = int32(v)
		}

		// Aceita CREATED, PARTIALLY_SPONSORED, ou PENDING (migração)
		validStatuses := []int32{
			int32(pb.TicketStatus_TICKET_CREATED),
			int32(pb.TicketStatus_TICKET_PARTIALLY_SPONSORED),
			int32(pb.ReservationStatus_PENDING),
		}
		isValidStatus := false
		for _, vs := range validStatuses {
			if currentStatusInt == vs {
				isValidStatus = true
				break
			}
		}
		if !isValidStatus {
			return status.Errorf(codes.FailedPrecondition, "reservation cannot be sponsored (status: %d)", currentStatusInt)
		}

		// Extrair dados da reserva
		userId = getString(data, "user_id")
		originalPrice = getFloat64(data, "original_price")
		if originalPrice == 0 {
			originalPrice = getFloat64(data, "total_price")
		}
		garageName = getString(data, "garage_name")
		garageId = getString(data, "garage_id")
		vehiclePlate = getString(data, "vehicle_plate")

		// Calcular saldo atual (pode já ter sido parcialmente patrocinado)
		currentBalance = getFloat64(data, "current_balance")
		if currentBalance == 0 {
			currentBalance = originalPrice // Primeira vez
		}
		totalSponsored = getFloat64(data, "total_sponsored")

		// Determinar valor a patrocinar
		amountToSponsor := req.GetAmountToSponsor()
		if amountToSponsor <= 0 {
			// Se não especificado, patrocina o saldo total restante
			amountToSponsor = currentBalance
		}
		if amountToSponsor > currentBalance {
			amountToSponsor = currentBalance // Não pode patrocinar mais que o saldo
		}

		// 4d. Marcar invoice como usada
		now := time.Now().Unix()
		err = tx.Set(invoiceRef, map[string]interface{}{
			"invoice_id":       invoiceID,
			"store_id":         storeID,
			"reservation_id":   reservationID,
			"amount_usd":       req.GetInvoice().GetAmountUsd(),
			"amount_sponsored": amountToSponsor,
			"used_at":          now,
		})
		if err != nil {
			return err
		}

		// 4e. Criar entrada no Ledger de Patrocínios (Sub-coleção)
		ledgerRef := s.firestoreClient.Collection(CollectionReservations).
			Doc(reservationID).
			Collection(CollectionSponsorshipLedger).
			NewDoc()
		ledgerEntryID = ledgerRef.ID

		err = tx.Set(ledgerRef, map[string]interface{}{
			"id":            ledgerEntryID,
			"store_id":      storeID,
			"store_name":    storeName,
			"amount":        amountToSponsor,
			"invoice_id":    invoiceID,
			"timestamp":     now,
			"sync_id":       syncID,
			"exchange_rate": exchangeRate,
			"operator_id":   claims.UserID,
		})
		if err != nil {
			return err
		}

		// 4f. Atualizar saldos e status da reserva
		newBalance := currentBalance - amountToSponsor
		newTotalSponsored := totalSponsored + amountToSponsor

		// Determinar novo status
		if newBalance <= 0 {
			newStatus = pb.TicketStatus_TICKET_SPONSORED
			newBalance = 0
		} else {
			newStatus = pb.TicketStatus_TICKET_PARTIALLY_SPONSORED
		}

		// Atualizar reserva com novos valores
		updates := []firestore.Update{
			{Path: "ticket_status", Value: int32(newStatus)},
			{Path: "current_balance", Value: newBalance},
			{Path: "total_sponsored", Value: newTotalSponsored},
			{Path: "last_sponsored_at", Value: now},
		}

		// Se totalmente patrocinado, adicionar campos legados para compatibilidade
		if newStatus == pb.TicketStatus_TICKET_SPONSORED {
			updates = append(updates,
				firestore.Update{Path: "amount_to_pay", Value: 0},
				firestore.Update{Path: "payer_id", Value: storeID},
				firestore.Update{Path: "payer_name", Value: storeName},
			)
		}

		err = tx.Update(reservationRef, updates)
		if err != nil {
			return err
		}

		// Atualizar variáveis de resultado
		currentBalance = newBalance
		totalSponsored = newTotalSponsored

		// 4g. Criar log de auditoria financial_pending
		financialRef := s.firestoreClient.Collection(CollectionFinancialPending).NewDoc()
		err = tx.Set(financialRef, map[string]interface{}{
			"type":            "SPONSORSHIP",
			"store_id":        storeID,
			"store_name":      storeName,
			"operator_id":     claims.UserID,
			"garage_id":       garageId,
			"garage_name":     garageName,
			"amount_brl":      amountToSponsor,
			"exchange_rate":   exchangeRate,
			"amount_usd":      amountToSponsor / exchangeRate,
			"reservation_id":  reservationID,
			"invoice_id":      invoiceID,
			"invoice_amount":  req.GetInvoice().GetAmountUsd(),
			"status":          "PENDING",
			"created_at":      now,
			"ledger_entry_id": ledgerEntryID,
			"is_partial":      newStatus == pb.TicketStatus_TICKET_PARTIALLY_SPONSORED,
		})
		if err != nil {
			return err
		}

		// 4h. Coletar resumo de patrocinadores para o voucher
		sponsorsSummary = append(sponsorsSummary, SponsorClaim{
			StoreName: storeName,
			Amount:    amountToSponsor,
		})

		return nil
	})

	// Tratar erros da transação
	if err != nil {
		if st, ok := status.FromError(err); ok {
			if st.Code() == codes.AlreadyExists {
				if syncID != "" && st.Message() == fmt.Sprintf("sync_id %s already processed", syncID) {
					// Idempotência: retornar sucesso
					return &pb.SponsorshipResponse{
						Success:   true,
						Message:   "Patrocínio já processado (idempotência)",
						NewStatus: newStatus,
					}, nil
				}
				return &pb.SponsorshipResponse{
					Success:   false,
					Message:   st.Message(),
					ErrorCode: "INVOICE_ALREADY_USED",
				}, nil
			}
		}
		return nil, err
	}

	// 5. Gerar voucher JWT se totalmente patrocinado
	var signedVoucher *pb.SignedVoucher
	if newStatus == pb.TicketStatus_TICKET_SPONSORED && s.voucherService != nil {
		voucherResult, err := s.voucherService.GenerateVoucher(
			reservationID,
			garageId,
			vehiclePlate,
			originalPrice,
			sponsorsSummary,
		)
		if err != nil {
			log.Printf("Warning: failed to generate voucher: %v", err)
		} else {
			signedVoucher = &pb.SignedVoucher{
				Jwt:        voucherResult.JWT,
				Jti:        voucherResult.JTI,
				ExpiresAt:  voucherResult.ExpiresAt,
				QrCodeData: voucherResult.JWT, // QR code contém o JWT
			}
		}
	}

	// 6. Dispara notificação FCM (goroutine para não bloquear resposta)
	go s.sendSponsorshipNotification(context.Background(), userId, storeName, reservationID)

	// 7. Retornar resposta com dados Multi-Sponsor
	return &pb.SponsorshipResponse{
		Success:         true,
		Message:         fmt.Sprintf("Patrocínio de R$ %.2f registrado por %s", totalSponsored-currentBalance, storeName),
		NewStatus:       newStatus,
		LedgerEntryId:   ledgerEntryID,
		AmountSponsored: totalSponsored - currentBalance,
		CurrentBalance:  currentBalance,
		TotalSponsored:  totalSponsored,
		ExchangeRate:    exchangeRate,
		Voucher:         signedVoucher,
	}, nil
}

// ==================== GetVoucherStatus ====================
// App faz polling para verificar status do voucher

func (s *PaymentService) GetVoucherStatus(ctx context.Context, req *pb.GetVoucherStatusRequest) (*pb.VoucherStatus, error) {
	if req.GetReservationId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "reservation_id is required")
	}

	doc, err := s.firestoreClient.Collection(CollectionReservations).Doc(req.GetReservationId()).Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "reservation not found")
	}

	data := doc.Data()
	ticketStatus := getTicketStatus(data)

	return &pb.VoucherStatus{
		ReservationId: req.GetReservationId(),
		Status:        ticketStatus,
		PayerId:       getString(data, "payer_id"),
		PayerName:     getString(data, "payer_name"),
		OriginalPrice: getFloat64(data, "original_price"),
		AmountToPay:   getFloat64(data, "amount_to_pay"),
	}, nil
}

// ==================== VerifyExit ====================
// Guarda da guarita verifica se veículo pode sair

func (s *PaymentService) VerifyExit(ctx context.Context, req *pb.VerifyExitRequest) (*pb.VerifyExitResponse, error) {
	// 1. RBAC: Apenas PARTNER_PARKING pode executar
	claims, err := auth.RequireRole(ctx, auth.RolePartnerParking, auth.RoleAdmin)
	if err != nil {
		return nil, err
	}

	// 2. Usar garage_id do contexto (segurança - guarda só vê sua garagem)
	garageID := claims.PartnerID
	if garageID == "" {
		// Fallback para request (admin pode consultar qualquer garagem)
		garageID = req.GetGarageId()
	}

	if req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "vehicle_plate is required")
	}

	// 3. Buscar reserva ativa por placa e garagem
	iter := s.firestoreClient.Collection(CollectionReservations).
		Where("garage_id", "==", garageID).
		Where("vehicle_plate", "==", req.GetVehiclePlate()).
		OrderBy("created_at", firestore.Desc).
		Limit(1).
		Documents(ctx)

	doc, err := iter.Next()
	if err != nil {
		return &pb.VerifyExitResponse{
			Authorized:     false,
			Message:        "Veículo não encontrado",
			DisplayMessage: "VEÍCULO NÃO REGISTRADO",
			ActionRequired: "VALIDATE_INVOICE",
		}, nil
	}

	data := doc.Data()
	ticketStatus := getTicketStatus(data)
	payerName := getString(data, "payer_name")
	originalPrice := getFloat64(data, "original_price")
	if originalPrice == 0 {
		originalPrice = getFloat64(data, "total_price")
	}

	switch ticketStatus {
	case pb.TicketStatus_TICKET_SPONSORED:
		return &pb.VerifyExitResponse{
			Authorized:     true,
			Message:        "AUTHORIZED",
			DisplayMessage: fmt.Sprintf("Boa viagem! Cortesia da %s 🎉", payerName),
			Status:         pb.TicketStatus_TICKET_SPONSORED,
			PayerName:      payerName,
			ActionRequired: "NONE",
			AmountDue:      0,
		}, nil

	case pb.TicketStatus_TICKET_COMPLETED:
		return &pb.VerifyExitResponse{
			Authorized:     false,
			Message:        "Ticket já utilizado",
			DisplayMessage: "TICKET JÁ USADO",
			Status:         pb.TicketStatus_TICKET_COMPLETED,
			ActionRequired: "NONE",
		}, nil

	default: // CREATED ou outros
		return &pb.VerifyExitResponse{
			Authorized:     false,
			Message:        "Pagamento necessário",
			DisplayMessage: fmt.Sprintf("PAGAMENTO PENDENTE: R$ %.2f", originalPrice),
			Status:         ticketStatus,
			ActionRequired: "PAYMENT_REQUIRED",
			AmountDue:      originalPrice,
		}, nil
	}
}

// ==================== ConfirmExit ====================
// Guarda confirma saída física do veículo

func (s *PaymentService) ConfirmExit(ctx context.Context, req *pb.ConfirmExitRequest) (*pb.ConfirmExitResponse, error) {
	// 1. RBAC: Apenas PARTNER_PARKING pode confirmar saída
	claims, err := auth.RequireRole(ctx, auth.RolePartnerParking, auth.RoleAdmin)
	if err != nil {
		return nil, err
	}

	// 2. Usar garage_id do contexto (segurança)
	garageID := claims.PartnerID
	if garageID == "" {
		garageID = req.GetGarageId()
	}

	if req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "vehicle_plate is required")
	}

	// 3. Buscar reserva ativa
	iter := s.firestoreClient.Collection(CollectionReservations).
		Where("garage_id", "==", garageID).
		Where("vehicle_plate", "==", req.GetVehiclePlate()).
		OrderBy("created_at", firestore.Desc).
		Limit(1).
		Documents(ctx)

	doc, err := iter.Next()
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "reservation not found")
	}

	// Atualizar para COMPLETED
	now := time.Now().Unix()
	_, err = doc.Ref.Update(ctx, []firestore.Update{
		{Path: "ticket_status", Value: int32(pb.TicketStatus_TICKET_COMPLETED)},
		{Path: "completed_at", Value: now},
		{Path: "exit_agent_id", Value: req.GetAgentId()},
	})
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to confirm exit: %v", err)
	}

	return &pb.ConfirmExitResponse{
		Success:     true,
		Message:     "Saída confirmada com sucesso",
		FinalStatus: pb.TicketStatus_TICKET_COMPLETED,
	}, nil
}

// ==================== GetSponsorshipLedger ====================
// Retorna o histórico de patrocínios de uma reserva

func (s *PaymentService) GetSponsorshipLedger(ctx context.Context, req *pb.GetSponsorshipLedgerRequest) (*pb.SponsorshipLedgerResponse, error) {
	// RBAC: USER, PARTNER_STORE ou ADMIN podem ver
	_, err := auth.RequireRole(ctx, auth.RoleUser, auth.RolePartnerStore, auth.RoleAdmin)
	if err != nil {
		return nil, err
	}

	if req.GetReservationId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "reservation_id is required")
	}

	// Buscar entradas do ledger
	ledgerRef := s.firestoreClient.Collection(CollectionReservations).
		Doc(req.GetReservationId()).
		Collection(CollectionSponsorshipLedger).
		OrderBy("timestamp", firestore.Desc)

	docs, err := ledgerRef.Documents(ctx).GetAll()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to fetch ledger: %v", err)
	}

	var entries []*pb.SponsorshipLedgerEntry
	var totalSponsored float64

	for _, doc := range docs {
		data := doc.Data()
		entry := &pb.SponsorshipLedgerEntry{
			EntryId:      getString(data, "id"),
			StoreId:      getString(data, "store_id"),
			StoreName:    getString(data, "store_name"),
			Amount:       getFloat64(data, "amount"),
			InvoiceId:    getString(data, "invoice_id"),
			Timestamp:    getInt64(data, "timestamp"),
			SyncId:       getString(data, "sync_id"),
			ExchangeRate: getFloat64(data, "exchange_rate"),
			OperatorId:   getString(data, "operator_id"),
		}
		entries = append(entries, entry)
		totalSponsored += entry.Amount
	}

	return &pb.SponsorshipLedgerResponse{
		ReservationId:  req.GetReservationId(),
		Entries:        entries,
		TotalSponsored: totalSponsored,
		EntryCount:     int32(len(entries)),
	}, nil
}

// ==================== RegisterUsedVoucher ====================
// Registra que um voucher foi usado (anti-fraude para validação offline)

func (s *PaymentService) RegisterUsedVoucher(ctx context.Context, req *pb.RegisterUsedVoucherRequest) (*pb.RegisterUsedVoucherResponse, error) {
	// RBAC: Apenas PARTNER_PARKING ou ADMIN podem registrar
	claims, err := auth.RequireRole(ctx, auth.RolePartnerParking, auth.RoleAdmin)
	if err != nil {
		return nil, err
	}

	if req.GetJti() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "jti is required")
	}

	// Verificar se voucher já foi usado
	voucherRef := s.firestoreClient.Collection(CollectionUsedVouchers).Doc(req.GetJti())
	voucherDoc, err := voucherRef.Get(ctx)
	if err == nil && voucherDoc.Exists() {
		// Voucher já usado - Anti-Fraude!
		data := voucherDoc.Data()
		return &pb.RegisterUsedVoucherResponse{
			Success:      false,
			ErrorCode:    "VOUCHER_ALREADY_USED",
			Message:      fmt.Sprintf("Voucher já utilizado em %s", time.Unix(getInt64(data, "used_at"), 0).Format("02/01/2006 15:04")),
			UsedAt:       getInt64(data, "used_at"),
			UsedByGarage: getString(data, "garage_id"),
		}, nil
	}

	// Registrar uso do voucher
	now := time.Now().Unix()
	_, err = voucherRef.Set(ctx, map[string]interface{}{
		"jti":            req.GetJti(),
		"reservation_id": req.GetReservationId(),
		"garage_id":      claims.PartnerID,
		"operator_id":    claims.UserID,
		"used_at":        now,
		"sync_id":        req.GetSyncId(), // Para reconciliação offline
		"vehicle_plate":  req.GetVehiclePlate(),
	})
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to register voucher: %v", err)
	}

	// Log de BI
	go s.logBIEvent(context.Background(), "VOUCHER_VERIFIED", map[string]interface{}{
		"jti":            req.GetJti(),
		"reservation_id": req.GetReservationId(),
		"garage_id":      claims.PartnerID,
		"operator_id":    claims.UserID,
		"timestamp":      now,
		"sync_id":        req.GetSyncId(),
	})

	return &pb.RegisterUsedVoucherResponse{
		Success: true,
		Message: "Voucher validado com sucesso",
		UsedAt:  now,
	}, nil
}

// ==================== LogBIEvent ====================
// Registra eventos para inteligência de dados

func (s *PaymentService) logBIEvent(ctx context.Context, eventType string, data map[string]interface{}) {
	data["event_type"] = eventType
	data["logged_at"] = time.Now().Unix()

	_, err := s.firestoreClient.Collection(CollectionBIEvents).NewDoc().Set(ctx, data)
	if err != nil {
		log.Printf("Warning: failed to log BI event: %v", err)
	}
}

// ==================== FCM Notification ====================

func (s *PaymentService) sendSponsorshipNotification(ctx context.Context, userId, storeName, reservationId string) {
	if s.fcmClient == nil {
		log.Printf("FCM client not available, skipping notification for user %s", userId)
		return
	}

	// Buscar FCM token do usuário
	userDoc, err := s.firestoreClient.Collection(CollectionUsers).Doc(userId).Get(ctx)
	if err != nil {
		log.Printf("Error fetching user %s for FCM: %v", userId, err)
		return
	}

	data := userDoc.Data()
	fcmToken := getString(data, "fcm_token")
	if fcmToken == "" {
		log.Printf("No FCM token for user %s", userId)
		return
	}

	// Enviar notificação
	message := &messaging.Message{
		Token: fcmToken,
		Notification: &messaging.Notification{
			Title: "Estacionamento Pago! 🚗✅",
			Body:  fmt.Sprintf("A %s validou a sua compra e cobriu o custo do seu estacionamento. Volte tranquilo!", storeName),
		},
		Data: map[string]string{
			"type":           "SPONSORSHIP_CONFIRMED",
			"reservation_id": reservationId,
		},
	}

	_, err = s.fcmClient.Send(ctx, message)
	if err != nil {
		log.Printf("Error sending FCM to user %s: %v", userId, err)
		return
	}

	log.Printf("FCM notification sent successfully to user %s", userId)
}

// ==================== Helpers ====================

func getTicketStatus(data map[string]interface{}) pb.TicketStatus {
	// Tentar ler ticket_status primeiro
	if v, ok := data["ticket_status"].(int64); ok {
		return pb.TicketStatus(v)
	}
	// Fallback para status antigo (migração)
	if v, ok := data["status"].(int64); ok {
		switch pb.ReservationStatus(v) {
		case pb.ReservationStatus_PENDING, pb.ReservationStatus_ACTIVE:
			return pb.TicketStatus_TICKET_CREATED
		case pb.ReservationStatus_COMPLETED:
			return pb.TicketStatus_TICKET_COMPLETED
		}
	}
	return pb.TicketStatus_TICKET_CREATED
}
