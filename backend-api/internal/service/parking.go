package service

import (
	"context"
	"math"
	"time"

	"cloud.google.com/go/firestore"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"github.com/mmcloughlin/geohash"
	"google.golang.org/api/iterator"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ParkingService struct {
	pb.UnimplementedParkingServiceServer
	firestoreClient *firestore.Client
	vehicleService  *VehicleService // Delegação para operações de veículos
}

func NewParkingService(client *firestore.Client, vehicleService *VehicleService) *ParkingService {
	return &ParkingService{
		firestoreClient: client,
		vehicleService:  vehicleService,
	}
}

// ==================== Busca de Garagens ====================

func (s *ParkingService) SearchGarages(ctx context.Context, req *pb.SearchRequest) (*pb.SearchResponse, error) {
	userLat := req.GetLatitude()
	userLng := req.GetLongitude()
	hash := geohash.Encode(userLat, userLng)
	searchHash := hash[:5]

	iter := s.firestoreClient.Collection("garages").
		Where("geohash", ">=", searchHash).
		Where("geohash", "<", searchHash+"\uf8ff").
		Documents(ctx)

	var garages []*pb.Garage

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, status.Errorf(codes.Internal, "failed to iterate garages: %v", err)
		}

		data := doc.Data()
		gLat := getFloat64(data, "latitude")
		gLng := getFloat64(data, "longitude")

		if distance(userLat, userLng, gLat, gLng) > float64(req.RadiusMeters) {
			continue
		}

		garages = append(garages, docToGarage(doc))
	}

	return &pb.SearchResponse{Garages: garages}, nil
}

func (s *ParkingService) GetGarage(ctx context.Context, req *pb.GetGarageRequest) (*pb.Garage, error) {
	doc, err := s.firestoreClient.Collection("garages").Doc(req.GetGarageId()).Get(ctx)
	if err != nil {
		if status.Code(err) == codes.NotFound {
			return nil, status.Errorf(codes.NotFound, "garage not found: %s", req.GetGarageId())
		}
		return nil, status.Errorf(codes.Internal, "failed to get garage: %v", err)
	}

	return docToGarage(doc), nil
}

// ==================== Sistema de Reservas ====================

func (s *ParkingService) CreateReservation(ctx context.Context, req *pb.CreateReservationRequest) (*pb.Reservation, error) {
	// Validações básicas
	if req.GetUserId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "user_id is required")
	}
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id is required")
	}
	if req.GetStartTime() >= req.GetEndTime() {
		return nil, status.Errorf(codes.InvalidArgument, "start_time must be before end_time")
	}

	// Buscar garagem para calcular preço
	garageDoc, err := s.firestoreClient.Collection("garages").Doc(req.GetGarageId()).Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "garage not found: %s", req.GetGarageId())
	}
	garageData := garageDoc.Data()
	garageName := getString(garageData, "name")
	basePrice := getFloat64(garageData, "base_price")

	// Calcular preço total (basePrice por hora)
	hours := float64(req.GetEndTime()-req.GetStartTime()) / 3600.0
	totalPrice := basePrice * hours

	// Criar documento de reserva
	now := time.Now().Unix()
	reservationRef := s.firestoreClient.Collection("reservations").NewDoc()

	reservation := map[string]interface{}{
		"user_id":       req.GetUserId(),
		"garage_id":     req.GetGarageId(),
		"garage_name":   garageName,
		"start_time":    req.GetStartTime(),
		"end_time":      req.GetEndTime(),
		"vehicle_plate": req.GetVehiclePlate(),
		"total_price":   totalPrice,
		"status":        int32(pb.ReservationStatus_PENDING),
		"created_at":    now,
	}

	_, err = reservationRef.Set(ctx, reservation)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create reservation: %v", err)
	}

	return &pb.Reservation{
		Id:           reservationRef.ID,
		UserId:       req.GetUserId(),
		GarageId:     req.GetGarageId(),
		GarageName:   garageName,
		StartTime:    req.GetStartTime(),
		EndTime:      req.GetEndTime(),
		VehiclePlate: req.GetVehiclePlate(),
		TotalPrice:   totalPrice,
		Status:       pb.ReservationStatus_PENDING,
		CreatedAt:    now,
	}, nil
}

func (s *ParkingService) ListReservations(ctx context.Context, req *pb.ListReservationsRequest) (*pb.ListReservationsResponse, error) {
	if req.GetUserId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "user_id is required")
	}

	query := s.firestoreClient.Collection("reservations").Where("user_id", "==", req.GetUserId())

	// Filtro opcional por status
	if req.GetStatusFilter() != pb.ReservationStatus_RESERVATION_STATUS_UNSPECIFIED {
		query = query.Where("status", "==", int32(req.GetStatusFilter()))
	}

	iter := query.OrderBy("created_at", firestore.Desc).Documents(ctx)

	var reservations []*pb.Reservation

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, status.Errorf(codes.Internal, "failed to list reservations: %v", err)
		}

		reservations = append(reservations, docToReservation(doc))
	}

	return &pb.ListReservationsResponse{Reservations: reservations}, nil
}

func (s *ParkingService) CancelReservation(ctx context.Context, req *pb.CancelReservationRequest) (*pb.CancelReservationResponse, error) {
	if req.GetReservationId() == "" || req.GetUserId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "reservation_id and user_id are required")
	}

	docRef := s.firestoreClient.Collection("reservations").Doc(req.GetReservationId())
	doc, err := docRef.Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "reservation not found")
	}

	data := doc.Data()
	if getString(data, "user_id") != req.GetUserId() {
		return nil, status.Errorf(codes.PermissionDenied, "you can only cancel your own reservations")
	}

	currentStatus := pb.ReservationStatus(getInt32(data, "status"))
	if currentStatus == pb.ReservationStatus_CANCELLED {
		return &pb.CancelReservationResponse{
			Success: false,
			Message: "Reservation is already cancelled",
		}, nil
	}
	if currentStatus == pb.ReservationStatus_COMPLETED {
		return &pb.CancelReservationResponse{
			Success: false,
			Message: "Cannot cancel a completed reservation",
		}, nil
	}

	_, err = docRef.Update(ctx, []firestore.Update{
		{Path: "status", Value: int32(pb.ReservationStatus_CANCELLED)},
	})
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to cancel reservation: %v", err)
	}

	return &pb.CancelReservationResponse{
		Success: true,
		Message: "Reservation cancelled successfully",
	}, nil
}

// ==================== Helpers ====================

func docToGarage(doc *firestore.DocumentSnapshot) *pb.Garage {
	data := doc.Data()

	var campaigns []*pb.Campaign
	if camps, ok := data["campaigns"].([]interface{}); ok {
		for _, c := range camps {
			cMap := c.(map[string]interface{})
			campaigns = append(campaigns, &pb.Campaign{
				PartnerName:  getString(cMap, "partner_name"),
				DiscountRule: getString(cMap, "discount_rule"),
			})
		}
	}

	return &pb.Garage{
		Id:             doc.Ref.ID,
		Name:           getString(data, "name"),
		BasePrice:      getFloat64(data, "base_price"),
		Latitude:       getFloat64(data, "latitude"),
		Longitude:      getFloat64(data, "longitude"),
		ImageUrl:       getString(data, "image_url"),
		Campaigns:      campaigns,
		Address:        getString(data, "address"),
		Phone:          getString(data, "phone"),
		TotalSpots:     getInt32(data, "total_spots"),
		AvailableSpots: getInt32(data, "available_spots"),
		Amenities:      getStringSlice(data, "amenities"),
	}
}

func docToReservation(doc *firestore.DocumentSnapshot) *pb.Reservation {
	data := doc.Data()
	return &pb.Reservation{
		Id:           doc.Ref.ID,
		UserId:       getString(data, "user_id"),
		GarageId:     getString(data, "garage_id"),
		GarageName:   getString(data, "garage_name"),
		StartTime:    getInt64(data, "start_time"),
		EndTime:      getInt64(data, "end_time"),
		VehiclePlate: getString(data, "vehicle_plate"),
		TotalPrice:   getFloat64(data, "total_price"),
		Status:       pb.ReservationStatus(getInt32(data, "status")),
		CreatedAt:    getInt64(data, "created_at"),
	}
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
	if v, ok := data[key].(int32); ok {
		return v
	}
	return 0
}

func getInt64(data map[string]interface{}, key string) int64 {
	if v, ok := data[key].(int64); ok {
		return v
	}
	return 0
}

func getStringSlice(data map[string]interface{}, key string) []string {
	if v, ok := data[key].([]interface{}); ok {
		result := make([]string, 0, len(v))
		for _, item := range v {
			if s, ok := item.(string); ok {
				result = append(result, s)
			}
		}
		return result
	}
	return nil
}

func distance(lat1, lon1, lat2, lon2 float64) float64 {
	const R = 6371000
	dLat := (lat2 - lat1) * (math.Pi / 180.0)
	dLon := (lon2 - lon1) * (math.Pi / 180.0)

	a := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Cos(lat1*(math.Pi/180.0))*math.Cos(lat2*(math.Pi/180.0))*
			math.Sin(dLon/2)*math.Sin(dLon/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))

	return R * c
}

// ==================== Delegação para VehicleService ====================

// RecordVehicleEntry delega para o VehicleService (B+Tree local)
func (s *ParkingService) RecordVehicleEntry(ctx context.Context, req *pb.VehicleEntryRequest) (*pb.VehicleEntryResponse, error) {
	return s.vehicleService.RecordVehicleEntry(ctx, req)
}

// RecordVehicleExit delega para o VehicleService
func (s *ParkingService) RecordVehicleExit(ctx context.Context, req *pb.VehicleExitRequest) (*pb.VehicleExitResponse, error) {
	return s.vehicleService.RecordVehicleExit(ctx, req)
}

// GetActiveVehicles delega para o VehicleService
func (s *ParkingService) GetActiveVehicles(ctx context.Context, req *pb.GetActiveVehiclesRequest) (*pb.GetActiveVehiclesResponse, error) {
	return s.vehicleService.GetActiveVehicles(ctx, req)
}

// GetVehicleEntry delega para o VehicleService
func (s *ParkingService) GetVehicleEntry(ctx context.Context, req *pb.GetVehicleEntryRequest) (*pb.VehicleEntry, error) {
	return s.vehicleService.GetVehicleEntry(ctx, req)
}
