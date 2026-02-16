package main

import (
	"context"
	"time"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/iterator"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// AuthService implementa gestão de usuários, parceiros e staff
type AuthService struct {
	firestoreClient *firestore.Client
}

func NewAuthService(client *firestore.Client) *AuthService {
	return &AuthService{firestoreClient: client}
}

// RegisterAuthServiceServer registra o serviço no servidor gRPC
// (até que o proto gere o código, usamos interface manual)
func RegisterAuthServiceServer(s *grpc.Server, srv *AuthService) {
	// Será substituído pelo registro gerado pelo protoc
	_ = s
	_ = srv
}

// RegisterUser registra um novo usuário (App Cliente)
func (s *AuthService) RegisterUser(ctx context.Context, firebaseUID, email, displayName, phone string) (map[string]interface{}, error) {
	if firebaseUID == "" || email == "" {
		return nil, status.Errorf(codes.InvalidArgument, "firebase_uid and email required")
	}

	// Verificar se já existe
	doc, err := s.firestoreClient.Collection("users").Doc(firebaseUID).Get(ctx)
	if err == nil && doc.Exists() {
		return nil, status.Errorf(codes.AlreadyExists, "user already registered")
	}

	now := time.Now().Unix()
	userData := map[string]interface{}{
		"email":        email,
		"display_name": displayName,
		"phone":        phone,
		"role":         "USER",
		"created_at":   now,
		"last_login":   now,
	}

	_, err = s.firestoreClient.Collection("users").Doc(firebaseUID).Set(ctx, userData)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to register user: %v", err)
	}

	userData["user_id"] = firebaseUID
	return userData, nil
}

// RegisterPartner registra um novo parceiro (Loja ou Estacionamento)
func (s *AuthService) RegisterPartner(ctx context.Context, firebaseUID, email, businessName, cnpj, phone, address, partnerType string, lat, lng float64) (map[string]interface{}, error) {
	if firebaseUID == "" || email == "" || businessName == "" {
		return nil, status.Errorf(codes.InvalidArgument, "firebase_uid, email and business_name required")
	}

	now := time.Now().Unix()

	// Determinar role baseada no tipo de parceiro
	role := "PARTNER_STORE"
	if partnerType == "PARKING_GARAGE" {
		role = "PARTNER_PARKING"
	}

	// Criar parceiro
	partnerRef := s.firestoreClient.Collection("partners").NewDoc()
	partnerData := map[string]interface{}{
		"business_name": businessName,
		"cnpj":          cnpj,
		"phone":         phone,
		"address":       address,
		"partner_type":  partnerType,
		"latitude":      lat,
		"longitude":     lng,
		"owner_uid":     firebaseUID,
		"created_at":    now,
		"active":        true,
	}

	_, err := partnerRef.Set(ctx, partnerData)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to register partner: %v", err)
	}

	// Criar/atualizar user com role de parceiro
	userData := map[string]interface{}{
		"email":        email,
		"display_name": businessName,
		"phone":        phone,
		"role":         role,
		"partner_id":   partnerRef.ID,
		"partner_name": businessName,
		"created_at":   now,
		"last_login":   now,
	}

	_, err = s.firestoreClient.Collection("users").Doc(firebaseUID).Set(ctx, userData)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create partner user: %v", err)
	}

	result := map[string]interface{}{
		"partner_id": partnerRef.ID,
		"user_id":    firebaseUID,
		"role":       role,
	}
	return result, nil
}

// GetProfile busca perfil do usuário
func (s *AuthService) GetProfile(ctx context.Context, userID string) (map[string]interface{}, error) {
	if userID == "" {
		return nil, status.Errorf(codes.InvalidArgument, "user_id required")
	}

	// Tentar users primeiro
	doc, err := s.firestoreClient.Collection("users").Doc(userID).Get(ctx)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "user not found")
	}

	data := doc.Data()
	data["user_id"] = userID
	return data, nil
}

// UpdateProfile atualiza perfil do usuário
func (s *AuthService) UpdateProfile(ctx context.Context, userID, displayName, phone, avatarURL string) (map[string]interface{}, error) {
	if userID == "" {
		return nil, status.Errorf(codes.InvalidArgument, "user_id required")
	}

	updates := []firestore.Update{}
	if displayName != "" {
		updates = append(updates, firestore.Update{Path: "display_name", Value: displayName})
	}
	if phone != "" {
		updates = append(updates, firestore.Update{Path: "phone", Value: phone})
	}
	if avatarURL != "" {
		updates = append(updates, firestore.Update{Path: "avatar_url", Value: avatarURL})
	}

	if len(updates) == 0 {
		return nil, status.Errorf(codes.InvalidArgument, "no fields to update")
	}

	_, err := s.firestoreClient.Collection("users").Doc(userID).Update(ctx, updates)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to update profile: %v", err)
	}

	return s.GetProfile(ctx, userID)
}

// ListPartnerStaff lista funcionários de um parceiro
func (s *AuthService) ListPartnerStaff(ctx context.Context, partnerID string) ([]map[string]interface{}, error) {
	if partnerID == "" {
		return nil, status.Errorf(codes.InvalidArgument, "partner_id required")
	}

	iter := s.firestoreClient.Collection("users").
		Where("partner_id", "==", partnerID).
		Documents(ctx)

	var staff []map[string]interface{}
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, status.Errorf(codes.Internal, "failed to list staff: %v", err)
		}
		data := doc.Data()
		data["user_id"] = doc.Ref.ID
		staff = append(staff, data)
	}

	return staff, nil
}

// AddPartnerStaff adiciona um funcionário ao parceiro
func (s *AuthService) AddPartnerStaff(ctx context.Context, partnerID, staffEmail, staffName, role string) (string, error) {
	if partnerID == "" || staffEmail == "" {
		return "", status.Errorf(codes.InvalidArgument, "partner_id and staff_email required")
	}

	// Buscar nome do parceiro
	partnerDoc, err := s.firestoreClient.Collection("partners").Doc(partnerID).Get(ctx)
	if err != nil {
		return "", status.Errorf(codes.NotFound, "partner not found")
	}
	partnerData := partnerDoc.Data()
	partnerName := ""
	if v, ok := partnerData["business_name"].(string); ok {
		partnerName = v
	}

	if role == "" {
		role = "PARTNER_STORE"
	}

	staffRef := s.firestoreClient.Collection("users").NewDoc()
	staffData := map[string]interface{}{
		"email":        staffEmail,
		"display_name": staffName,
		"role":         role,
		"partner_id":   partnerID,
		"partner_name": partnerName,
		"created_at":   time.Now().Unix(),
		"is_staff":     true,
	}

	_, err = staffRef.Set(ctx, staffData)
	if err != nil {
		return "", status.Errorf(codes.Internal, "failed to add staff: %v", err)
	}

	return staffRef.ID, nil
}

// RemovePartnerStaff remove um funcionário
func (s *AuthService) RemovePartnerStaff(ctx context.Context, partnerID, staffID string) error {
	if partnerID == "" || staffID == "" {
		return status.Errorf(codes.InvalidArgument, "partner_id and staff_id required")
	}

	// Verificar que o staff pertence ao parceiro
	doc, err := s.firestoreClient.Collection("users").Doc(staffID).Get(ctx)
	if err != nil {
		return status.Errorf(codes.NotFound, "staff not found")
	}

	data := doc.Data()
	if pid, ok := data["partner_id"].(string); !ok || pid != partnerID {
		return status.Errorf(codes.PermissionDenied, "staff does not belong to this partner")
	}

	_, err = s.firestoreClient.Collection("users").Doc(staffID).Delete(ctx)
	if err != nil {
		return status.Errorf(codes.Internal, "failed to remove staff: %v", err)
	}

	return nil
}
