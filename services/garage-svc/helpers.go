package main

import (
	"math"

	"cloud.google.com/go/firestore"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
)

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
