package service

import (
	"crypto/ed25519"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

const (
	VoucherValidityMinutes = 60 // Voucher válido por 60 minutos após geração
	EnvVoucherPrivateKey   = "VOUCHER_PRIVATE_KEY"
	EnvVoucherPublicKey    = "VOUCHER_PUBLIC_KEY"
)

// SponsorClaim representa um patrocinador no voucher
type SponsorClaim struct {
	StoreName string  `json:"store_name"`
	Amount    float64 `json:"amount"`
}

// VoucherClaims são as claims do JWT do voucher
type VoucherClaims struct {
	jwt.RegisteredClaims
	ReservationID string         `json:"reservation_id"`
	GarageID      string         `json:"garage_id"`
	VehiclePlate  string         `json:"vehicle_plate"`
	OriginalPrice float64        `json:"original_price"`
	Sponsors      []SponsorClaim `json:"sponsors"`
}

// VoucherResult é o resultado da geração do voucher
type VoucherResult struct {
	JWT       string
	JTI       string
	ExpiresAt int64
}

// VoucherService é responsável por gerar e validar vouchers JWT
type VoucherService struct {
	privateKey ed25519.PrivateKey
	publicKey  ed25519.PublicKey
}

// NewVoucherService cria uma nova instância do VoucherService
func NewVoucherService() (*VoucherService, error) {
	// Tentar carregar chaves do ambiente
	privateKeyB64 := os.Getenv(EnvVoucherPrivateKey)
	publicKeyB64 := os.Getenv(EnvVoucherPublicKey)

	var privateKey ed25519.PrivateKey
	var publicKey ed25519.PublicKey
	var err error

	if privateKeyB64 != "" && publicKeyB64 != "" {
		// Decodificar chaves do ambiente
		privateKey, err = base64.StdEncoding.DecodeString(privateKeyB64)
		if err != nil {
			return nil, fmt.Errorf("failed to decode private key: %w", err)
		}
		publicKey, err = base64.StdEncoding.DecodeString(publicKeyB64)
		if err != nil {
			return nil, fmt.Errorf("failed to decode public key: %w", err)
		}
	} else {
		// Gerar novas chaves (apenas para desenvolvimento)
		log.Println("Warning: Generating new Ed25519 keypair. Set VOUCHER_PRIVATE_KEY and VOUCHER_PUBLIC_KEY for production!")
		publicKey, privateKey, err = ed25519.GenerateKey(rand.Reader)
		if err != nil {
			return nil, fmt.Errorf("failed to generate keypair: %w", err)
		}

		// Log das chaves para que possam ser configuradas
		log.Printf("Generated Public Key (base64): %s", base64.StdEncoding.EncodeToString(publicKey))
		log.Printf("Generated Private Key (base64): %s", base64.StdEncoding.EncodeToString(privateKey))
	}

	return &VoucherService{
		privateKey: privateKey,
		publicKey:  publicKey,
	}, nil
}

// GenerateVoucher gera um voucher JWT assinado
func (v *VoucherService) GenerateVoucher(
	reservationID string,
	garageID string,
	vehiclePlate string,
	originalPrice float64,
	sponsors []SponsorClaim,
) (*VoucherResult, error) {
	if v.privateKey == nil {
		return nil, fmt.Errorf("private key not initialized")
	}

	jti := uuid.New().String()
	now := time.Now()
	expiresAt := now.Add(time.Duration(VoucherValidityMinutes) * time.Minute)

	claims := VoucherClaims{
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        jti,
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(expiresAt),
			Issuer:    "parkingzero/backend",
			Subject:   reservationID,
		},
		ReservationID: reservationID,
		GarageID:      garageID,
		VehiclePlate:  vehiclePlate,
		OriginalPrice: originalPrice,
		Sponsors:      sponsors,
	}

	token := jwt.NewWithClaims(jwt.SigningMethodEdDSA, claims)
	signedToken, err := token.SignedString(v.privateKey)
	if err != nil {
		return nil, fmt.Errorf("failed to sign token: %w", err)
	}

	return &VoucherResult{
		JWT:       signedToken,
		JTI:       jti,
		ExpiresAt: expiresAt.Unix(),
	}, nil
}

// ValidateVoucher valida um voucher JWT sem conexão com servidor
// Esta função é usada pelo app do guarda offline
func (v *VoucherService) ValidateVoucher(tokenString string) (*VoucherClaims, error) {
	if v.publicKey == nil {
		return nil, fmt.Errorf("public key not initialized")
	}

	token, err := jwt.ParseWithClaims(tokenString, &VoucherClaims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodEd25519); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return v.publicKey, nil
	})

	if err != nil {
		return nil, fmt.Errorf("failed to parse token: %w", err)
	}

	if claims, ok := token.Claims.(*VoucherClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, fmt.Errorf("invalid token")
}

// GetPublicKeyBase64 retorna a chave pública em base64 para distribuição
// O app do guarda precisa dessa chave para validar vouchers offline
func (v *VoucherService) GetPublicKeyBase64() string {
	return base64.StdEncoding.EncodeToString(v.publicKey)
}
