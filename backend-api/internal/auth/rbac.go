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
	RoleUser           = "USER"            // Usuário comum (App Usuário)
	RolePartnerStore   = "PARTNER_STORE"   // Funcionário de Loja (App Business)
	RolePartnerParking = "PARTNER_PARKING" // Funcionário de Estacionamento (App Business)
	RoleAdmin          = "ADMIN"           // Administrador
)

// UserClaims representa as claims do usuário autenticado
type UserClaims struct {
	UserID      string
	Email       string
	Role        string
	PartnerID   string // ID da Loja ou Estacionamento vinculado
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
		// Extrair metadata (headers) da requisição
		md, ok := metadata.FromIncomingContext(ctx)
		if !ok {
			// Permitir requisições sem auth para métodos públicos
			return handler(ctx, req)
		}

		// Extrair token de autorização
		authHeader := md.Get("authorization")
		if len(authHeader) == 0 {
			// Sem token - continuar sem claims (métodos públicos)
			return handler(ctx, req)
		}

		token := strings.TrimPrefix(authHeader[0], "Bearer ")
		if token == "" {
			return handler(ctx, req)
		}

		// Buscar claims do usuário no Firestore
		claims, err := fetchUserClaims(ctx, firestoreClient, token)
		if err != nil {
			// Log do erro mas não bloqueia - métodos decidem se precisam de auth
			return handler(ctx, req)
		}

		// Adicionar claims ao contexto
		ctx = context.WithValue(ctx, UserClaimsKey, claims)
		return handler(ctx, req)
	}
}

// fetchUserClaims busca as claims do usuário no Firestore
// O token aqui é o Firebase UID (já validado pelo Firebase Auth no client)
func fetchUserClaims(ctx context.Context, client *firestore.Client, userID string) (*UserClaims, error) {
	// Primeiro tenta buscar na coleção users
	userDoc, err := client.Collection("users").Doc(userID).Get(ctx)
	if err == nil && userDoc.Exists() {
		data := userDoc.Data()
		return &UserClaims{
			UserID:      userID,
			Email:       getString(data, "email"),
			Role:        getString(data, "role"),
			PartnerID:   getString(data, "partner_id"),
			PartnerName: getString(data, "partner_name"),
		}, nil
	}

	// Se não encontrou, tenta na coleção partners (funcionários de parceiros)
	partnerDoc, err := client.Collection("partners").Doc(userID).Get(ctx)
	if err == nil && partnerDoc.Exists() {
		data := partnerDoc.Data()
		return &UserClaims{
			UserID:      userID,
			Email:       getString(data, "email"),
			Role:        getString(data, "role"),
			PartnerID:   getString(data, "partner_id"),
			PartnerName: getString(data, "partner_name"),
		}, nil
	}

	// Usuário não encontrado - retorna role padrão USER
	return &UserClaims{
		UserID: userID,
		Role:   RoleUser,
	}, nil
}

// Helper para extrair string de map
func getString(data map[string]interface{}, key string) string {
	if v, ok := data[key].(string); ok {
		return v
	}
	return ""
}
