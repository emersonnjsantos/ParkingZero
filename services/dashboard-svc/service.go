package main

import (
	"context"
	"log"
	"time"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/iterator"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// DashboardService implementa analytics e relatórios
type DashboardService struct {
	firestoreClient *firestore.Client
}

func NewDashboardService(client *firestore.Client) *DashboardService {
	return &DashboardService{firestoreClient: client}
}

// RegisterDashboardServiceServer registra o serviço no servidor gRPC
func RegisterDashboardServiceServer(s *grpc.Server, srv *DashboardService) {
	_ = s
	_ = srv
}

// GetParkingSummary retorna resumo geral do estacionamento
func (s *DashboardService) GetParkingSummary(ctx context.Context, garageID string, fromTs, toTs int64) (map[string]interface{}, error) {
	if garageID == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id required")
	}

	if fromTs == 0 {
		fromTs = time.Now().Add(-24 * time.Hour).Unix()
	}
	if toTs == 0 {
		toTs = time.Now().Unix()
	}

	// Buscar entradas de veículos no período
	iter := s.firestoreClient.Collection("vehicle_entries").
		Where("garage_id", "==", garageID).
		Where("entry_time", ">=", fromTs).
		Where("entry_time", "<=", toTs).
		Documents(ctx)

	var totalEntries, totalExits, currentOccupancy int32
	var totalRevenue, totalDuration float64

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		data := doc.Data()
		totalEntries++

		statusVal := int32(0)
		if v, ok := data["status"].(int64); ok {
			statusVal = int32(v)
		}

		if statusVal == 2 { // EXITED
			totalExits++
			if v, ok := data["amount_paid"].(float64); ok {
				totalRevenue += v
			}
			entryTime := getInt64(data, "entry_time")
			exitTime := getInt64(data, "exit_time")
			if exitTime > entryTime {
				totalDuration += float64(exitTime - entryTime)
			}
		} else {
			currentOccupancy++
		}
	}

	// Buscar total patrocinado
	ledgerIter := s.firestoreClient.Collection("sponsorship_ledger").
		Where("timestamp", ">=", fromTs).
		Where("timestamp", "<=", toTs).
		Documents(ctx)

	var totalSponsored float64
	for {
		doc, err := ledgerIter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		if v, ok := doc.Data()["amount"].(float64); ok {
			totalSponsored += v
		}
	}

	avgStay := 0.0
	if totalExits > 0 {
		avgStay = (totalDuration / float64(totalExits)) / 3600.0
	}

	return map[string]interface{}{
		"garage_id":          garageID,
		"total_entries":      totalEntries,
		"total_exits":        totalExits,
		"current_occupancy":  currentOccupancy,
		"total_revenue":      totalRevenue,
		"total_sponsored":    totalSponsored,
		"average_stay_hours": avgStay,
		"period_start":       fromTs,
		"period_end":         toTs,
	}, nil
}

// GetRevenueReport retorna relatório de receita por período
func (s *DashboardService) GetRevenueReport(ctx context.Context, garageID, period string, fromTs, toTs int64) (map[string]interface{}, error) {
	if garageID == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id required")
	}

	if period == "" {
		period = "day"
	}
	if fromTs == 0 {
		switch period {
		case "week":
			fromTs = time.Now().Add(-7 * 24 * time.Hour).Unix()
		case "month":
			fromTs = time.Now().Add(-30 * 24 * time.Hour).Unix()
		default:
			fromTs = time.Now().Add(-24 * time.Hour).Unix()
		}
	}
	if toTs == 0 {
		toTs = time.Now().Unix()
	}

	// Buscar todas as saídas no período
	iter := s.firestoreClient.Collection("vehicle_entries").
		Where("garage_id", "==", garageID).
		Where("exit_time", ">=", fromTs).
		Where("exit_time", "<=", toTs).
		Where("status", "==", int32(2)). // EXITED
		Documents(ctx)

	dailyMap := make(map[string]*dailyData)
	var totalRevenue float64
	var totalTransactions int32

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		data := doc.Data()

		exitTime := getInt64(data, "exit_time")
		date := time.Unix(exitTime, 0).Format("2006-01-02")
		amount := 0.0
		if v, ok := data["amount_paid"].(float64); ok {
			amount = v
		}

		if _, exists := dailyMap[date]; !exists {
			dailyMap[date] = &dailyData{Date: date}
		}
		dailyMap[date].Revenue += amount
		dailyMap[date].Exits++
		totalRevenue += amount
		totalTransactions++
	}

	// Buscar patrocínios
	ledgerIter := s.firestoreClient.Collection("sponsorship_ledger").
		Where("timestamp", ">=", fromTs).
		Where("timestamp", "<=", toTs).
		Documents(ctx)

	var totalSponsored float64
	for {
		doc, err := ledgerIter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		if v, ok := doc.Data()["amount"].(float64); ok {
			totalSponsored += v
			ts := getInt64(doc.Data(), "timestamp")
			date := time.Unix(ts, 0).Format("2006-01-02")
			if _, exists := dailyMap[date]; !exists {
				dailyMap[date] = &dailyData{Date: date}
			}
			dailyMap[date].Sponsored += v
		}
	}

	var daily []map[string]interface{}
	for _, d := range dailyMap {
		daily = append(daily, map[string]interface{}{
			"date":      d.Date,
			"revenue":   d.Revenue,
			"sponsored": d.Sponsored,
			"entries":   d.Entries,
			"exits":     d.Exits,
		})
	}

	return map[string]interface{}{
		"garage_id":          garageID,
		"total_revenue":      totalRevenue,
		"total_sponsored":    totalSponsored,
		"net_revenue":        totalRevenue - totalSponsored,
		"daily_breakdown":    daily,
		"total_transactions": totalTransactions,
	}, nil
}

type dailyData struct {
	Date      string
	Revenue   float64
	Sponsored float64
	Entries   int32
	Exits     int32
}

// GetStoreSponsorshipSummary retorna resumo de patrocínios para lojas
func (s *DashboardService) GetStoreSponsorshipSummary(ctx context.Context, storeID string, fromTs, toTs int64) (map[string]interface{}, error) {
	if storeID == "" {
		return nil, status.Errorf(codes.InvalidArgument, "store_id required")
	}

	if fromTs == 0 {
		fromTs = time.Now().Add(-30 * 24 * time.Hour).Unix()
	}
	if toTs == 0 {
		toTs = time.Now().Unix()
	}

	iter := s.firestoreClient.Collection("sponsorship_ledger").
		Where("store_id", "==", storeID).
		Where("timestamp", ">=", fromTs).
		Where("timestamp", "<=", toTs).
		Documents(ctx)

	var totalSpent float64
	var totalSponsorships int32
	var totalInvoice float64
	customers := make(map[string]bool)
	monthlyMap := make(map[string]*monthlyData)

	storeName := ""

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		data := doc.Data()

		amount := 0.0
		if v, ok := data["amount"].(float64); ok {
			amount = v
		}

		if sn, ok := data["store_name"].(string); ok && storeName == "" {
			storeName = sn
		}

		ts := getInt64(data, "timestamp")
		month := time.Unix(ts, 0).Format("2006-01")

		totalSpent += amount
		totalSponsorships++

		if resID, ok := data["reservation_id"].(string); ok {
			customers[resID] = true
		}

		if inv, ok := data["invoice_amount"].(float64); ok {
			totalInvoice += inv
		}

		if _, exists := monthlyMap[month]; !exists {
			monthlyMap[month] = &monthlyData{Month: month}
		}
		monthlyMap[month].AmountSpent += amount
		monthlyMap[month].SponsorshipCount++
	}

	avgInvoice := 0.0
	if totalSponsorships > 0 && totalInvoice > 0 {
		avgInvoice = totalInvoice / float64(totalSponsorships)
	}

	var monthly []map[string]interface{}
	for _, m := range monthlyMap {
		monthly = append(monthly, map[string]interface{}{
			"month":             m.Month,
			"amount_spent":      m.AmountSpent,
			"sponsorship_count": m.SponsorshipCount,
			"customer_count":    m.CustomerCount,
		})
	}

	return map[string]interface{}{
		"store_id":           storeID,
		"store_name":         storeName,
		"total_spent":        totalSpent,
		"total_sponsorships": totalSponsorships,
		"unique_customers":   len(customers),
		"average_invoice":    avgInvoice,
		"monthly":            monthly,
	}, nil
}

type monthlyData struct {
	Month            string
	AmountSpent      float64
	SponsorshipCount int32
	CustomerCount    int32
}

// GetOccupancyStats retorna ocupação em tempo real
func (s *DashboardService) GetOccupancyStats(ctx context.Context, garageID string) (map[string]interface{}, error) {
	if garageID == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id required")
	}

	// Buscar dados da garagem
	garageDoc, err := s.firestoreClient.Collection("garages").Doc(garageID).Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "garage not found")
	}

	garageData := garageDoc.Data()
	totalSpots := int32(0)
	if v, ok := garageData["total_spots"].(int64); ok {
		totalSpots = int32(v)
	}

	// Contar veículos ativos
	iter := s.firestoreClient.Collection("vehicle_entries").
		Where("garage_id", "==", garageID).
		Where("status", "==", int32(1)). // PARKED
		Documents(ctx)

	var occupiedSpots int32
	for {
		_, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			break
		}
		occupiedSpots++
	}

	availableSpots := totalSpots - occupiedSpots
	if availableSpots < 0 {
		availableSpots = 0
	}

	occupancyRate := 0.0
	if totalSpots > 0 {
		occupancyRate = float64(occupiedSpots) / float64(totalSpots)
	}

	return map[string]interface{}{
		"garage_id":       garageID,
		"total_spots":     totalSpots,
		"occupied_spots":  occupiedSpots,
		"available_spots": availableSpots,
		"occupancy_rate":  occupancyRate,
	}, nil
}

// ListBIEvents lista eventos de business intelligence
func (s *DashboardService) ListBIEvents(ctx context.Context, eventType string, fromTs, toTs int64, limit int) ([]map[string]interface{}, int, error) {
	query := s.firestoreClient.Collection("bi_events").Query

	if eventType != "" {
		query = query.Where("event_type", "==", eventType)
	}
	if fromTs > 0 {
		query = query.Where("timestamp", ">=", fromTs)
	}
	if toTs > 0 {
		query = query.Where("timestamp", "<=", toTs)
	}
	if limit <= 0 {
		limit = 50
	}
	query = query.OrderBy("timestamp", firestore.Desc).Limit(limit)

	iter := query.Documents(ctx)

	var events []map[string]interface{}
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Printf("⚠️ Error iterating BI events: %v\n", err)
			break
		}
		data := doc.Data()
		data["event_id"] = doc.Ref.ID
		events = append(events, data)
	}

	return events, len(events), nil
}

// === Helpers ===

func getInt64(data map[string]interface{}, key string) int64 {
	if v, ok := data[key].(int64); ok {
		return v
	}
	return 0
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

// logEvent registra um evento BI sobre acesso ao dashboard
func (s *DashboardService) logEvent(ctx context.Context, eventType string, data map[string]interface{}) {
	data["event_type"] = eventType
	data["timestamp"] = time.Now().Unix()
	data["source"] = "dashboard-svc"
	s.firestoreClient.Collection("bi_events").NewDoc().Set(ctx, data)
}
