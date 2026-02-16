package auth

import (
	"context"
	"strings"

	"cloud.google.com/go/firestore"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

// Roles do sistema
const (
	RoleUser           = "USER"
	RolePartnerStore   = "PARTNER_STORE"
	RolePartnerParking = "PARTNER_PARKING"
	RoleAdmin          = "ADMIN"
)

// UserClaims representa as claims do usuário autenticado
type UserClaims struct {
	UserID      string
	Email       string
	Role        string
	PartnerID   string
	PartnerName string
}

// ContextKey para armazenar claims no contexto
type contextKey string

const UserClaimsKey contextKey = "user_claims"

// GetUserClaims extrai as claims do contexto
func GetUserClaims(ctx context.Context) (*UserClaims, error) {
	claims, ok := ctx.Value(UserClaimsKey).(*UserClaims)
	if !ok || claims == nil {
		return nil, status.Errorf(codes.Unauthenticated, "user not authenticated")
	}
	return claims, nil
}

// RequireRole valida se o usuário tem a role necessária
func RequireRole(ctx context.Context, allowedRoles ...string) (*UserClaims, error) {
	claims, err := GetUserClaims(ctx)
	if err != nil {
		return nil, err
	}

	for _, role := range allowedRoles {
		if claims.Role == role {
			return claims, nil
		}
	}

	return nil, status.Errorf(codes.PermissionDenied,
		"access denied: role '%s' not authorized for this operation", claims.Role)
}

// AuthInterceptor cria um interceptor gRPC para autenticação
func AuthInterceptor(firestoreClient *firestore.Client) grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
		md, ok := metadata.FromIncomingContext(ctx)
		if !ok {
			return handler(ctx, req)
		}

		authHeader := md.Get("authorization")
		if len(authHeader) == 0 {
			return handler(ctx, req)
		}

		token := strings.TrimPrefix(authHeader[0], "Bearer ")
		if token == "" {
			return handler(ctx, req)
		}

		claims, err := fetchUserClaims(ctx, firestoreClient, token)
		if err != nil {
			return handler(ctx, req)
		}

		ctx = context.WithValue(ctx, UserClaimsKey, claims)
		return handler(ctx, req)
	}
}

// fetchUserClaims busca as claims do usuário no Firestore
func fetchUserClaims(ctx context.Context, client *firestore.Client, userID string) (*UserClaims, error) {
	userDoc, err := client.Collection("users").Doc(userID).Get(ctx)
	if err == nil && userDoc.Exists() {
		data := userDoc.Data()
		return &UserClaims{
			UserID:      userID,
			Email:       GetString(data, "email"),
			Role:        GetString(data, "role"),
			PartnerID:   GetString(data, "partner_id"),
			PartnerName: GetString(data, "partner_name"),
		}, nil
	}

	partnerDoc, err := client.Collection("partners").Doc(userID).Get(ctx)
	if err == nil && partnerDoc.Exists() {
		data := partnerDoc.Data()
		return &UserClaims{
			UserID:      userID,
			Email:       GetString(data, "email"),
			Role:        GetString(data, "role"),
			PartnerID:   GetString(data, "partner_id"),
			PartnerName: GetString(data, "partner_name"),
		}, nil
	}

	return &UserClaims{
		UserID: userID,
		Role:   RoleUser,
	}, nil
}

// GetString é um helper para extrair string de map (exportado para uso pelos serviços)
func GetString(data map[string]interface{}, key string) string {
	if v, ok := data[key].(string); ok {
		return v
	}
	return ""
}
