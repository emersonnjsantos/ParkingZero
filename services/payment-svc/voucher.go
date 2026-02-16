package main

import (
	"crypto/ed25519"
	"encoding/base64"
	"fmt"
	"log"
	"os"
	"time"

	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"github.com/golang-jwt/jwt/v5"
)

// VoucherService gerencia geração e validação de vouchers JWT com Ed25519
type VoucherService struct {
	privateKey ed25519.PrivateKey
	publicKey  ed25519.PublicKey
}

// VoucherClaims define as claims do JWT voucher
type VoucherClaims struct {
	jwt.RegisteredClaims
	ReservationID string             `json:"reservation_id"`
	VehiclePlate  string             `json:"vehicle_plate"`
	GarageID      string             `json:"garage_id"`
	Sponsors      map[string]float64 `json:"sponsors"`
}

// NewVoucherService cria o serviço de vouchers
func NewVoucherService() *VoucherService {
	vs := &VoucherService{}

	// Tentar carregar chave do ambiente
	if keyStr := os.Getenv("VOUCHER_ED25519_KEY"); keyStr != "" {
		keyBytes, err := base64.StdEncoding.DecodeString(keyStr)
		if err == nil && len(keyBytes) == ed25519.SeedSize {
			vs.privateKey = ed25519.NewKeyFromSeed(keyBytes)
			vs.publicKey = vs.privateKey.Public().(ed25519.PublicKey)
			log.Println("🔑 Chave Ed25519 carregada do ambiente")
			return vs
		}
		log.Printf("⚠️  Chave inválida no ambiente, gerando nova\n")
	}

	// Gerar novo par de chaves
	pub, priv, err := ed25519.GenerateKey(nil)
	if err != nil {
		log.Fatalf("❌ Erro ao gerar chave Ed25519: %v\n", err)
	}
	vs.privateKey = priv
	vs.publicKey = pub

	seed := priv.Seed()
	log.Printf("🔑 Nova chave Ed25519 gerada. VOUCHER_ED25519_KEY=%s\n",
		base64.StdEncoding.EncodeToString(seed))

	return vs
}

// GenerateVoucher gera um JWT assinado para validação offline
func (vs *VoucherService) GenerateVoucher(
	reservationID, vehiclePlate, garageID string,
	sponsors map[string]float64,
) (*pb.SignedVoucher, error) {
	now := time.Now()
	expiresAt := now.Add(24 * time.Hour)

	jti := fmt.Sprintf("v_%s_%d", reservationID, now.UnixMilli())

	claims := VoucherClaims{
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        jti,
			Issuer:    "parkingzero-payment-svc",
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(expiresAt),
			Subject:   reservationID,
		},
		ReservationID: reservationID,
		VehiclePlate:  vehiclePlate,
		GarageID:      garageID,
		Sponsors:      sponsors,
	}

	token := jwt.NewWithClaims(jwt.SigningMethodEdDSA, claims)
	signedJWT, err := token.SignedString(vs.privateKey)
	if err != nil {
		return nil, fmt.Errorf("erro ao assinar JWT: %w", err)
	}

	qrData := fmt.Sprintf("PZ:%s:%s:%s", jti, garageID, vehiclePlate)

	return &pb.SignedVoucher{
		Jwt:        signedJWT,
		Jti:        jti,
		ExpiresAt:  expiresAt.Unix(),
		QrCodeData: qrData,
	}, nil
}

// ValidateVoucher valida um JWT voucher offline
func (vs *VoucherService) ValidateVoucher(tokenString string) (*VoucherClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &VoucherClaims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodEd25519); !ok {
			return nil, fmt.Errorf("signing method inesperado: %v", token.Header["alg"])
		}
		return vs.publicKey, nil
	})

	if err != nil {
		return nil, fmt.Errorf("token inválido: %w", err)
	}

	claims, ok := token.Claims.(*VoucherClaims)
	if !ok || !token.Valid {
		return nil, fmt.Errorf("claims inválidas")
	}

	return claims, nil
}

// GetPublicKey retorna a chave pública para distribuição
func (vs *VoucherService) GetPublicKey() ed25519.PublicKey {
	return vs.publicKey
}
