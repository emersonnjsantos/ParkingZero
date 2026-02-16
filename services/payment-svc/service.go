package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"cloud.google.com/go/firestore"
	"firebase.google.com/go/messaging"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"google.golang.org/api/iterator"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// PaymentService implementa o sistema de patrocínio multi-sponsor
type PaymentService struct {
	pb.UnimplementedPaymentServiceServer
	firestoreClient *firestore.Client
	fcmClient       *messaging.Client
	voucherService  *VoucherService
}

func NewPaymentService(client *firestore.Client, fcm *messaging.Client, voucher *VoucherService) *PaymentService {
	return &PaymentService{
		firestoreClient: client,
		fcmClient:       fcm,
		voucherService:  voucher,
	}
}

// RequestSponsorship processa pedido de patrocínio de loja
func (s *PaymentService) RequestSponsorship(ctx context.Context, req *pb.SponsorshipRequest) (*pb.SponsorshipResponse, error) {
	if req.GetReservationId() == "" || req.GetStoreId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "reservation_id and store_id required")
	}

	if req.GetInvoice() == nil || req.GetInvoice().GetAmountUsd() < 200 {
		return &pb.SponsorshipResponse{
			Success:   false,
			Message:   "Valor mínimo da nota fiscal: $200.00",
			ErrorCode: "INVOICE_TOO_LOW",
		}, nil
	}

	// Idempotência por sync_id
	if req.GetSyncId() != "" {
		existing := s.firestoreClient.Collection("sponsorship_ledger").
			Where("sync_id", "==", req.GetSyncId()).
			Documents(ctx)
		doc, _ := existing.Next()
		if doc != nil {
			return &pb.SponsorshipResponse{
				Success: true,
				Message: "Patrocínio já processado (idempotente)",
			}, nil
		}
	}

	// Transação atômica no Firestore
	var response *pb.SponsorshipResponse
	err := s.firestoreClient.RunTransaction(ctx, func(ctx context.Context, tx *firestore.Transaction) error {
		// Buscar reserva
		resRef := s.firestoreClient.Collection("reservations").Doc(req.GetReservationId())
		resDoc, err := tx.Get(resRef)
		if err != nil {
			return fmt.Errorf("reserva não encontrada: %w", err)
		}

		data := resDoc.Data()
		totalPrice := getFloat64(data, "total_price")
		currentBalance := getFloat64(data, "current_balance")
		if currentBalance == 0 {
			currentBalance = totalPrice
		}
		totalSponsored := getFloat64(data, "total_sponsored")

		// Calcular novo patrocínio
		amountToSponsor := req.GetAmountToSponsor()
		if amountToSponsor <= 0 || amountToSponsor > currentBalance {
			amountToSponsor = currentBalance
		}

		newBalance := currentBalance - amountToSponsor
		newTotalSponsored := totalSponsored + amountToSponsor

		var newStatus pb.TicketStatus
		if newBalance <= 0 {
			newStatus = pb.TicketStatus_TICKET_SPONSORED
			newBalance = 0
		} else {
			newStatus = pb.TicketStatus_TICKET_PARTIALLY_SPONSORED
		}

		// Atualizar reserva
		tx.Update(resRef, []firestore.Update{
			{Path: "current_balance", Value: newBalance},
			{Path: "total_sponsored", Value: newTotalSponsored},
			{Path: "ticket_status", Value: int32(newStatus)},
			{Path: "updated_at", Value: time.Now().Unix()},
		})

		// Criar entry no ledger
		ledgerRef := s.firestoreClient.Collection("sponsorship_ledger").NewDoc()
		exchangeRate := amountToSponsor / req.GetInvoice().GetAmountUsd()

		tx.Set(ledgerRef, map[string]interface{}{
			"reservation_id": req.GetReservationId(),
			"store_id":       req.GetStoreId(),
			"store_name":     req.GetInvoice().GetStoreName(),
			"amount":         amountToSponsor,
			"invoice_id":     req.GetInvoice().GetInvoiceId(),
			"timestamp":      time.Now().Unix(),
			"sync_id":        req.GetSyncId(),
			"exchange_rate":  exchangeRate,
		})

		// Gerar voucher JWT se totalmente patrocinado
		var voucher *pb.SignedVoucher
		if newStatus == pb.TicketStatus_TICKET_SPONSORED {
			vehiclePlate := getString(data, "vehicle_plate")
			garageID := getString(data, "garage_id")

			voucher, err = s.voucherService.GenerateVoucher(
				req.GetReservationId(),
				vehiclePlate,
				garageID,
				map[string]float64{
					req.GetInvoice().GetStoreName(): amountToSponsor,
				},
			)
			if err != nil {
				log.Printf("⚠️  Erro ao gerar voucher: %v\n", err)
			}
		}

		response = &pb.SponsorshipResponse{
			Success:         true,
			Message:         fmt.Sprintf("Patrocínio de R$ %.2f registrado", amountToSponsor),
			NewStatus:       newStatus,
			LedgerEntryId:   ledgerRef.ID,
			AmountSponsored: amountToSponsor,
			CurrentBalance:  newBalance,
			TotalSponsored:  newTotalSponsored,
			ExchangeRate:    exchangeRate,
			Voucher:         voucher,
		}

		return nil
	})

	if err != nil {
		return nil, status.Errorf(codes.Internal, "falha na transação: %v", err)
	}

	// Enviar notificação FCM
	go s.sendSponsorshipNotification(ctx, req.GetReservationId())

	// Registrar evento BI
	go s.logBIEvent(ctx, "sponsorship_created", map[string]interface{}{
		"reservation_id": req.GetReservationId(),
		"store_id":       req.GetStoreId(),
		"amount":         response.AmountSponsored,
	})

	return response, nil
}

// GetVoucherStatus retorna status do voucher
func (s *PaymentService) GetVoucherStatus(ctx context.Context, req *pb.GetVoucherStatusRequest) (*pb.VoucherStatus, error) {
	if req.GetReservationId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "reservation_id required")
	}

	resDoc, err := s.firestoreClient.Collection("reservations").Doc(req.GetReservationId()).Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "reserva não encontrada")
	}

	data := resDoc.Data()
	totalPrice := getFloat64(data, "total_price")
	currentBalance := getFloat64(data, "current_balance")
	if currentBalance == 0 {
		currentBalance = totalPrice
	}
	totalSponsored := getFloat64(data, "total_sponsored")

	ticketStatus := pb.TicketStatus(getInt32(data, "ticket_status"))
	if ticketStatus == pb.TicketStatus_TICKET_STATUS_UNSPECIFIED {
		ticketStatus = pb.TicketStatus_TICKET_CREATED
	}

	// Buscar sponsors
	var sponsors []*pb.SponsorSummary
	ledgerIter := s.firestoreClient.Collection("sponsorship_ledger").
		Where("reservation_id", "==", req.GetReservationId()).
		Documents(ctx)

	for {
		doc, err := ledgerIter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		d := doc.Data()
		sponsors = append(sponsors, &pb.SponsorSummary{
			StoreName: getString(d, "store_name"),
			Amount:    getFloat64(d, "amount"),
		})
	}

	return &pb.VoucherStatus{
		ReservationId:   req.GetReservationId(),
		Status:          ticketStatus,
		PayerId:         getString(data, "payer_id"),
		PayerName:       getString(data, "payer_name"),
		OriginalPrice:   totalPrice,
		AmountToPay:     currentBalance,
		CurrentBalance:  currentBalance,
		TotalSponsored:  totalSponsored,
		SponsorsSummary: sponsors,
	}, nil
}

// VerifyExit verifica se veículo pode sair
func (s *PaymentService) VerifyExit(ctx context.Context, req *pb.VerifyExitRequest) (*pb.VerifyExitResponse, error) {
	if req.GetGarageId() == "" || req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id and vehicle_plate required")
	}

	iter := s.firestoreClient.Collection("reservations").
		Where("garage_id", "==", req.GetGarageId()).
		Where("vehicle_plate", "==", req.GetVehiclePlate()).
		Where("status", "in", []int32{
			int32(pb.ReservationStatus_PENDING),
			int32(pb.ReservationStatus_ACTIVE),
		}).
		Documents(ctx)

	doc, err := iter.Next()
	if err != nil {
		return &pb.VerifyExitResponse{
			Authorized:     true,
			Message:        "Nenhuma reserva ativa - saída livre",
			DisplayMessage: "Saída autorizada",
			ActionRequired: "OPEN_GATE",
		}, nil
	}

	data := doc.Data()
	ticketStatus := pb.TicketStatus(getInt32(data, "ticket_status"))
	currentBalance := getFloat64(data, "current_balance")

	switch ticketStatus {
	case pb.TicketStatus_TICKET_SPONSORED:
		return &pb.VerifyExitResponse{
			Authorized:     true,
			Message:        "Estacionamento patrocinado",
			DisplayMessage: "✅ PATROCINADO - Saída liberada!",
			Status:         ticketStatus,
			PayerName:      getString(data, "payer_name"),
			ActionRequired: "OPEN_GATE",
		}, nil
	case pb.TicketStatus_TICKET_PARTIALLY_SPONSORED:
		return &pb.VerifyExitResponse{
			Authorized:     false,
			Message:        "Patrocínio parcial",
			DisplayMessage: fmt.Sprintf("⚠️ Saldo: R$ %.2f", currentBalance),
			Status:         ticketStatus,
			AmountDue:      currentBalance,
			ActionRequired: "COLLECT_PAYMENT",
		}, nil
	default:
		totalPrice := getFloat64(data, "total_price")
		return &pb.VerifyExitResponse{
			Authorized:     false,
			Message:        "Pagamento pendente",
			DisplayMessage: fmt.Sprintf("💰 Total: R$ %.2f", totalPrice),
			Status:         pb.TicketStatus_TICKET_CREATED,
			AmountDue:      totalPrice,
			ActionRequired: "COLLECT_PAYMENT",
		}, nil
	}
}

// ConfirmExit confirma saída física do veículo
func (s *PaymentService) ConfirmExit(ctx context.Context, req *pb.ConfirmExitRequest) (*pb.ConfirmExitResponse, error) {
	if req.GetGarageId() == "" || req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id and vehicle_plate required")
	}

	iter := s.firestoreClient.Collection("reservations").
		Where("garage_id", "==", req.GetGarageId()).
		Where("vehicle_plate", "==", req.GetVehiclePlate()).
		Where("status", "in", []int32{
			int32(pb.ReservationStatus_PENDING),
			int32(pb.ReservationStatus_ACTIVE),
		}).
		Documents(ctx)

	doc, err := iter.Next()
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "reserva não encontrada")
	}

	_, err = doc.Ref.Update(ctx, []firestore.Update{
		{Path: "status", Value: int32(pb.ReservationStatus_COMPLETED)},
		{Path: "ticket_status", Value: int32(pb.TicketStatus_TICKET_COMPLETED)},
		{Path: "completed_at", Value: time.Now().Unix()},
		{Path: "completed_by", Value: req.GetAgentId()},
	})
	if err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao confirmar saída: %v", err)
	}

	go s.logBIEvent(ctx, "exit_confirmed", map[string]interface{}{
		"garage_id":     req.GetGarageId(),
		"vehicle_plate": req.GetVehiclePlate(),
		"agent_id":      req.GetAgentId(),
	})

	return &pb.ConfirmExitResponse{
		Success:     true,
		Message:     "Saída confirmada",
		FinalStatus: pb.TicketStatus_TICKET_COMPLETED,
	}, nil
}

// GetSponsorshipLedger retorna histórico de patrocínios
func (s *PaymentService) GetSponsorshipLedger(ctx context.Context, req *pb.GetSponsorshipLedgerRequest) (*pb.SponsorshipLedgerResponse, error) {
	if req.GetReservationId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "reservation_id required")
	}

	// Buscar reserva
	resDoc, err := s.firestoreClient.Collection("reservations").Doc(req.GetReservationId()).Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "reserva não encontrada")
	}
	resData := resDoc.Data()

	// Buscar entradas do ledger
	iter := s.firestoreClient.Collection("sponsorship_ledger").
		Where("reservation_id", "==", req.GetReservationId()).
		OrderBy("timestamp", firestore.Asc).
		Documents(ctx)

	var entries []*pb.SponsorshipLedgerEntry
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		d := doc.Data()
		entries = append(entries, &pb.SponsorshipLedgerEntry{
			EntryId:      doc.Ref.ID,
			StoreId:      getString(d, "store_id"),
			StoreName:    getString(d, "store_name"),
			Amount:       getFloat64(d, "amount"),
			InvoiceId:    getString(d, "invoice_id"),
			Timestamp:    getInt64(d, "timestamp"),
			SyncId:       getString(d, "sync_id"),
			ExchangeRate: getFloat64(d, "exchange_rate"),
			OperatorId:   getString(d, "operator_id"),
		})
	}

	totalPrice := getFloat64(resData, "total_price")
	currentBalance := getFloat64(resData, "current_balance")
	if currentBalance == 0 {
		currentBalance = totalPrice
	}
	totalSponsored := getFloat64(resData, "total_sponsored")
	ticketStatus := pb.TicketStatus(getInt32(resData, "ticket_status"))

	return &pb.SponsorshipLedgerResponse{
		ReservationId:  req.GetReservationId(),
		OriginalPrice:  totalPrice,
		CurrentBalance: currentBalance,
		TotalSponsored: totalSponsored,
		Status:         ticketStatus,
		Entries:        entries,
		EntryCount:     int32(len(entries)),
	}, nil
}

// RegisterUsedVoucher registra um voucher usado
func (s *PaymentService) RegisterUsedVoucher(ctx context.Context, req *pb.RegisterUsedVoucherRequest) (*pb.RegisterUsedVoucherResponse, error) {
	if req.GetJti() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "jti required")
	}

	// Verificar se já foi usado
	existing, err := s.firestoreClient.Collection("used_vouchers").Doc(req.GetJti()).Get(ctx)
	if err == nil && existing.Exists() {
		d := existing.Data()
		return &pb.RegisterUsedVoucherResponse{
			Success:      false,
			Message:      "Voucher já foi utilizado",
			ErrorCode:    "ALREADY_USED",
			UsedAt:       getInt64(d, "used_at"),
			UsedByGarage: getString(d, "garage_id"),
		}, nil
	}

	now := time.Now().Unix()
	_, err = s.firestoreClient.Collection("used_vouchers").Doc(req.GetJti()).Set(ctx, map[string]interface{}{
		"jti":            req.GetJti(),
		"reservation_id": req.GetReservationId(),
		"garage_id":      req.GetGarageId(),
		"agent_id":       req.GetAgentId(),
		"used_at":        now,
		"vehicle_plate":  req.GetVehiclePlate(),
		"sync_id":        req.GetSyncId(),
	})

	if err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao registrar voucher: %v", err)
	}

	return &pb.RegisterUsedVoucherResponse{
		Success:      true,
		Message:      "Voucher registrado como utilizado",
		UsedAt:       now,
		UsedByGarage: req.GetGarageId(),
	}, nil
}

// === Helpers ===

func (s *PaymentService) sendSponsorshipNotification(ctx context.Context, reservationID string) {
	if s.fcmClient == nil {
		return
	}
	log.Printf("📱 Notificação FCM para reserva %s\n", reservationID)
}

func (s *PaymentService) logBIEvent(ctx context.Context, eventType string, data map[string]interface{}) {
	data["event_type"] = eventType
	data["timestamp"] = time.Now().Unix()
	s.firestoreClient.Collection("bi_events").NewDoc().Set(ctx, data)
}

func getString(data map[string]interface{}, key string) string {
	if v, ok := data[key].(string); ok {
		return v
	}
	return ""
}

func getFloat64(data map[string]interface{}, key string) float64 {
	if v, ok := data[key].(float64); ok {
		return v
	}
	return 0
}

func getInt32(data map[string]interface{}, key string) int32 {
	if v, ok := data[key].(int64); ok {
		return int32(v)
	}
	return 0
}

func getInt64(data map[string]interface{}, key string) int64 {
	if v, ok := data[key].(int64); ok {
		return v
	}
	return 0
}
