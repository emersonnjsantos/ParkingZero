package main

import (
	"context"
	"time"

	"cloud.google.com/go/firestore"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"github.com/mmcloughlin/geohash"
	"google.golang.org/api/iterator"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// GarageService gerencia operações de garagens e reservas
type GarageService struct {
	pb.UnimplementedParkingServiceServer
	firestoreClient *firestore.Client
}

func NewGarageService(client *firestore.Client) *GarageService {
	return &GarageService{
		firestoreClient: client,
	}
}

// ==================== Busca de Garagens ====================

func (s *GarageService) SearchGarages(ctx context.Context, req *pb.SearchRequest) (*pb.SearchResponse, error) {
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

func (s *GarageService) GetGarage(ctx context.Context, req *pb.GetGarageRequest) (*pb.Garage, error) {
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

func (s *GarageService) CreateReservation(ctx context.Context, req *pb.CreateReservationRequest) (*pb.Reservation, error) {
	if req.GetUserId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "user_id is required")
	}
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id is required")
	}
	if req.GetStartTime() >= req.GetEndTime() {
		return nil, status.Errorf(codes.InvalidArgument, "start_time must be before end_time")
	}

	garageDoc, err := s.firestoreClient.Collection("garages").Doc(req.GetGarageId()).Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "garage not found: %s", req.GetGarageId())
	}
	garageData := garageDoc.Data()
	garageName := getString(garageData, "name")
	basePrice := getFloat64(garageData, "base_price")

	hours := float64(req.GetEndTime()-req.GetStartTime()) / 3600.0
	totalPrice := basePrice * hours

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

func (s *GarageService) ListReservations(ctx context.Context, req *pb.ListReservationsRequest) (*pb.ListReservationsResponse, error) {
	if req.GetUserId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "user_id is required")
	}

	query := s.firestoreClient.Collection("reservations").Where("user_id", "==", req.GetUserId())

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

func (s *GarageService) CancelReservation(ctx context.Context, req *pb.CancelReservationRequest) (*pb.CancelReservationResponse, error) {
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
