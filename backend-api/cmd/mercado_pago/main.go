package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/database"
	"github.com/gin-gonic/gin"
)

// Configurações e Credenciais
const (
	AccessToken = "TEST-4823914184869735-011412-54f58e50ea6d7d6ac1edf6c1b2cfae44-174089404"
	MPApiUrl    = "https://api.mercadopago.com/v1"
)

type PayerIdentification struct {
	Type   string `json:"type"`
	Number string `json:"number"`
}

type PayerInfo struct {
	Email          string               `json:"email"`
	FirstName      string               `json:"first_name,omitempty"`
	LastName       string               `json:"last_name,omitempty"`
	Identification *PayerIdentification `json:"identification,omitempty"`
}

// Structs para Pagamento PIX
type PixPaymentRequest struct {
	TransactionAmount float64   `json:"transaction_amount"`
	Description       string    `json:"description"`
	Payer             PayerInfo `json:"payer"`
}

// Structs para Pagamento com Cartão
type CardPaymentRequest struct {
	Token             string    `json:"token"`
	TransactionAmount float64   `json:"transaction_amount"`
	Installments      int       `json:"installments"`
	PaymentMethodID   string    `json:"payment_method_id"` // ex: "master"
	Payer             PayerInfo `json:"payer"`
}

func main() {
	r := gin.Default()

	// Middleware de CORS para desenvolvimento local com Flutter
	r.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Grupo de rotas Mercado Pago
	api := r.Group("/api/payments")
	{
		api.POST("/pix", handlePixPayment)
		api.POST("/card", handleCardPayment)
		api.POST("/webhook", handleWebhookNotification)
	}

	port := "8085"
	log.Printf("💳 Servidor de Pagamentos Mercado Pago rodando na porta :%s\n", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Falha ao rodar o servidor: %v", err)
	}
}

// 1. Rota para criar Pagamento via PIX
func handlePixPayment(c *gin.Context) {
	var req PixPaymentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Payload inválido", "details": err.Error()})
		return
	}

	// Payload oficial do Mercado Pago para PIX
	payload := map[string]interface{}{
		"transaction_amount": req.TransactionAmount,
		"description":        req.Description,
		"payment_method_id":  "pix",
		"payer": map[string]interface{}{
			"email":      req.Payer.Email,
			"first_name": req.Payer.FirstName,
			"last_name":  req.Payer.LastName,
			"identification": map[string]interface{}{
				"type":   req.Payer.Identification.Type,
				"number": req.Payer.Identification.Number,
			},
		},
	}

	respBody, err := callMercadoPagoAPI("POST", "/payments", payload)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Falha na API do Mercado Pago", "details": err.Error()})
		return
	}

	// Parse da resposta do MP
	var mpResponse map[string]interface{}
	if err := json.Unmarshal(respBody, &mpResponse); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Erro ao decodificar resposta", "raw": string(respBody)})
		return
	}

	// Extrair QR Code e Copia e Cola
	pointOfInteraction, ok := mpResponse["point_of_interaction"].(map[string]interface{})
	var qrCode, qrCodeBase64 string
	if ok {
		transactionData, ok := pointOfInteraction["transaction_data"].(map[string]interface{})
		if ok {
			qrCode, _ = transactionData["qr_code"].(string)
			qrCodeBase64, _ = transactionData["qr_code_base64"].(string)
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"payment_id":      mpResponse["id"],
		"status":          mpResponse["status"],
		"status_detail":   mpResponse["status_detail"],
		"qr_code":         qrCode,          // Copia e Cola do Pix
		"qr_code_base64":  qrCodeBase64,   // Imagem Base64 do QR Code
		"created_at":      mpResponse["date_created"],
	})
}

// 2. Rota para criar Pagamento via Cartão de Crédito
func handleCardPayment(c *gin.Context) {
	var req CardPaymentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Payload inválido", "details": err.Error()})
		return
	}

	// Payload oficial do Mercado Pago para Token de Cartão
	payload := map[string]interface{}{
		"token":              req.Token,
		"transaction_amount": req.TransactionAmount,
		"installments":       req.Installments,
		"payment_method_id":  req.PaymentMethodID,
		"payer": map[string]interface{}{
			"email": req.Payer.Email,
		},
	}

	respBody, err := callMercadoPagoAPI("POST", "/payments", payload)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Falha na API do Mercado Pago", "details": err.Error()})
		return
	}

	var mpResponse map[string]interface{}
	if err := json.Unmarshal(respBody, &mpResponse); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Erro ao decodificar resposta", "raw": string(respBody)})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"payment_id":    mpResponse["id"],
		"status":        mpResponse["status"], // ex: "approved", "rejected"
		"status_detail": mpResponse["status_detail"],
		"message":       "Pagamento via cartão processado",
	})
}

// 3. Webhook para receber notificações do Mercado Pago
func handleWebhookNotification(c *gin.Context) {
	var notification map[string]interface{}
	if err := c.ShouldBindJSON(&notification); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Notificação inválida"})
		return
	}

	log.Printf("🔔 Notificação de Webhook recebida: %+v\n", notification)

	// Verificar se é uma notificação de pagamento
	action, _ := notification["action"].(string)
	dataType, _ := notification["type"].(string)

	if action == "payment.created" || action == "payment.updated" || dataType == "payment" {
		var paymentID string
		if data, ok := notification["data"].(map[string]interface{}); ok {
			if id, exists := data["id"]; exists {
				paymentID = fmt.Sprintf("%v", id)
			}
		}

		if paymentID != "" {
			log.Printf("🔍 Consultando status do pagamento ID: %s...\n", paymentID)
			respBody, err := callMercadoPagoAPI("GET", "/payments/"+paymentID, nil)
			if err == nil {
				var paymentDetails map[string]interface{}
				if err := json.Unmarshal(respBody, &paymentDetails); err == nil {
					status, _ := paymentDetails["status"].(string)
					log.Printf("💰 Status atual do pagamento %s: %s\n", paymentID, status)

					if status == "approved" {
						log.Printf("✅ Pagamento %s APROVADO! Atualizando status da vaga no banco de dados...\n", paymentID)
						
						// Integrando com o banco de dados B+Tree local do ParkingZero
						dbPath := "./parkingzero.db"
						db, err := database.Open(dbPath)
						if err == nil {
							defer db.Close()
							// Salva a transação aprovada na B+Tree local
							key := []byte(fmt.Sprintf("payment_%s", paymentID))
							value := []byte(fmt.Sprintf("status=approved;timestamp=%d;amount=%v", time.Now().Unix(), paymentDetails["transaction_amount"]))
							if err := db.Put(key, value); err == nil {
								log.Printf("💾 Status do pagamento salvo com sucesso na B+Tree local!")
							} else {
								log.Printf("⚠️ Erro ao salvar status na B+Tree: %v\n", err)
							}
						} else {
							log.Printf("⚠️ Erro ao abrir banco local B+Tree para atualização: %v\n", err)
						}
					}
				}
			}
		}
	}

	c.JSON(http.StatusOK, gin.H{"status": "received"})
}

// Helper para fazer requisições HTTP autenticadas para a API do Mercado Pago
func callMercadoPagoAPI(method, endpoint string, body interface{}) ([]byte, error) {
	var bodyReader io.Reader
	if body != nil {
		jsonBytes, err := json.Marshal(body)
		if err != nil {
			return nil, err
		}
		bodyReader = bytes.NewBuffer(jsonBytes)
	}

	req, err := http.NewRequest(method, MPApiUrl+endpoint, bodyReader)
	if err != nil {
		return nil, err
	}

	// Cabeçalhos de Autorização do MP com o Access Token de Teste
	req.Header.Set("Authorization", "Bearer "+AccessToken)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-Idempotency-Key", fmt.Sprintf("pz-%d", time.Now().UnixNano()))

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, fmt.Errorf("API retornou erro %d: %s", resp.StatusCode, string(respBody))
	}

	return respBody, nil
}
