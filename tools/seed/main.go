// Script completo para popular Firestore com dados de teste
// Popula: garages, reservations, sponsorship_ledger, vehicle_entries, bi_events
//
// Execute: go run tools/seed/main.go
// Variáveis de ambiente:
//   GOOGLE_CLOUD_PROJECT  (default: parking-zero-app)
//   SEED_MODE             (default: full | garages | reservations | sponsorships | all)

package main

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"github.com/mmcloughlin/geohash"
)

// ────────────────── Structs ──────────────────

type Garage struct {
	Name           string     `firestore:"name"`
	BasePrice      float64    `firestore:"base_price"`
	Latitude       float64    `firestore:"latitude"`
	Longitude      float64    `firestore:"longitude"`
	Geohash        string     `firestore:"geohash"`
	ImageUrl       string     `firestore:"image_url"`
	Address        string     `firestore:"address"`
	Phone          string     `firestore:"phone"`
	TotalSpots     int32      `firestore:"total_spots"`
	AvailableSpots int32      `firestore:"available_spots"`
	Amenities      []string   `firestore:"amenities"`
	Campaigns      []Campaign `firestore:"campaigns"`
}

type Campaign struct {
	PartnerName  string `firestore:"partner_name"`
	DiscountRule string `firestore:"discount_rule"`
}

// ────────────────── Main ──────────────────

func main() {
	ctx := context.Background()

	projectID := os.Getenv("GOOGLE_CLOUD_PROJECT")
	if projectID == "" {
		projectID = "parking-zero-app"
	}

	seedMode := os.Getenv("SEED_MODE")
	if seedMode == "" {
		seedMode = "full"
	}

	conf := &firebase.Config{ProjectID: projectID}
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		log.Fatalf("❌ Erro ao inicializar Firebase: %v\n", err)
	}

	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalf("❌ Erro ao conectar Firestore: %v\n", err)
	}
	defer client.Close()

	log.Printf("🔧 Projeto: %s | Modo: %s\n", projectID, seedMode)

	// IDs das garagens criadas (para referência cruzada)
	var garageIDs []string

	switch seedMode {
	case "garages":
		garageIDs = seedGarages(ctx, client)
	case "reservations":
		garageIDs = getExistingGarageIDs(ctx, client)
		seedReservationsAndLedger(ctx, client, garageIDs)
	case "sponsorships":
		garageIDs = getExistingGarageIDs(ctx, client)
		seedReservationsAndLedger(ctx, client, garageIDs)
	default: // "full" ou "all"
		garageIDs = seedGarages(ctx, client)
		seedReservationsAndLedger(ctx, client, garageIDs)
		seedVehicleEntries(ctx, client, garageIDs)
	}

	log.Println("\n🎉 Seed concluído com sucesso!")
}

// ────────────────── Garagens ──────────────────

func seedGarages(ctx context.Context, client *firestore.Client) []string {
	log.Println("\n📍 Criando garagens...")

	garages := []Garage{
		{
			Name:           "Estacionamento Shopping JL",
			BasePrice:      50.0,
			Latitude:       -25.5088,
			Longitude:      -54.6025,
			ImageUrl:       "https://images.unsplash.com/photo-1590674899484-d5640e854abe?w=400",
			Address:        "Av. República Argentina, 1700 - Foz do Iguaçu",
			Phone:          "(45) 3523-1234",
			TotalSpots:     150,
			AvailableSpots: 42,
			Amenities:      []string{"WiFi", "Segurança 24h", "Cobertura"},
			Campaigns: []Campaign{
				{PartnerName: "Loja Eletrônicos X", DiscountRule: "20% desconto - compras acima de R$500"},
			},
		},
		{
			Name:           "Garage Ponte da Amizade",
			BasePrice:      40.0,
			Latitude:       -25.5078,
			Longitude:      -54.6038,
			ImageUrl:       "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=400",
			Address:        "Rua Almirante Barroso, 850 - Centro",
			Phone:          "(45) 3574-5678",
			TotalSpots:     80,
			AvailableSpots: 15,
			Amenities:      []string{"Lavagem", "Vigilância"},
			Campaigns: []Campaign{
				{PartnerName: "Perfumaria Y", DiscountRule: "1h grátis - compras acima de R$200"},
			},
		},
		{
			Name:           "Parking Ciudad del Este",
			BasePrice:      35.0,
			Latitude:       -25.5095,
			Longitude:      -54.6055,
			ImageUrl:       "https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?w=400",
			Address:        "Próximo à Ponte - Lado Brasil",
			Phone:          "(45) 3029-9012",
			TotalSpots:     200,
			AvailableSpots: 73,
			Amenities:      []string{"Banheiro", "Lanchonete", "Segurança"},
			Campaigns: []Campaign{
				{PartnerName: "Casa China Z", DiscountRule: "30min grátis - qualquer compra"},
			},
		},
		{
			Name:           "EstacionaFácil Centro",
			BasePrice:      45.0,
			Latitude:       -25.5102,
			Longitude:      -54.6012,
			ImageUrl:       "https://images.unsplash.com/photo-1621929747188-0b4dc28498d2?w=400",
			Address:        "Av. Brasil, 1200 - Centro",
			Phone:          "(45) 3525-3456",
			TotalSpots:     60,
			AvailableSpots: 8,
			Amenities:      []string{"Cobertura", "Manobrista"},
			Campaigns: []Campaign{
				{PartnerName: "Loja Importados W", DiscountRule: "15% desconto - clientes cadastrados"},
			},
		},
		{
			Name:           "Park & Shop Duty Free",
			BasePrice:      55.0,
			Latitude:       -25.5070,
			Longitude:      -54.6045,
			ImageUrl:       "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=400",
			Address:        "Rua Marechal Deodoro, 500",
			Phone:          "(45) 3521-7890",
			TotalSpots:     100,
			AvailableSpots: 25,
			Amenities:      []string{"WiFi", "EV Charging", "Cobertura", "Segurança 24h"},
			Campaigns: []Campaign{
				{PartnerName: "Duty Free Foz", DiscountRule: "2h grátis - compras acima de US$100"},
				{PartnerName: "Restaurante Fogão", DiscountRule: "10% desconto no almoço"},
			},
		},
	}

	var ids []string
	for _, g := range garages {
		g.Geohash = geohash.Encode(g.Latitude, g.Longitude)
		docRef := client.Collection("garages").NewDoc()
		_, err := docRef.Set(ctx, g)
		if err != nil {
			log.Printf("  ❌ Erro ao inserir %s: %v\n", g.Name, err)
		} else {
			log.Printf("  ✅ Garagem: %s (ID: %s)\n", g.Name, docRef.ID)
			ids = append(ids, docRef.ID)
		}
	}
	log.Printf("  → %d garagens criadas\n", len(ids))
	return ids
}

// ────────────────── Reservas + Ledger ──────────────────

func seedReservationsAndLedger(ctx context.Context, client *firestore.Client, garageIDs []string) {
	log.Println("\n🅿️  Criando reservas e patrocínios...")

	if len(garageIDs) == 0 {
		log.Println("  ⚠️  Nenhuma garagem encontrada, pulando reservas")
		return
	}

	now := time.Now()

	// Lojas parceiras
	stores := []struct {
		ID   string
		Name string
	}{
		{ID: "store_loja_x", Name: "Loja Eletrônicos X"},
		{ID: "store_perfumaria_y", Name: "Perfumaria Y"},
		{ID: "store_casa_china", Name: "Casa China Z"},
		{ID: "store_duty_free", Name: "Duty Free Foz"},
		{ID: "store_importados_w", Name: "Loja Importados W"},
	}

	// Placas de veículos de teste
	plates := []string{
		"ABC-1234", "XYZ-5678", "DEF-9012", "GHI-3456",
		"JKL-7890", "MNO-1234", "PQR-5678", "STU-9012",
		"VWX-3456", "YZA-7890", "BCD-1357", "EFG-2468",
	}

	// Clientes de teste
	customers := []string{
		"Maria Silva", "João Santos", "Ana Costa", "Pedro Lima",
		"Carla Souza", "Lucas Oliveira", "Fernanda Mendes", "Rafael Pereira",
		"Juliana Almeida", "Bruno Ferreira", "Patricia Rocha", "Diego Martins",
	}

	var reservationIDs []string

	for i := 0; i < 12; i++ {
		garageID := garageIDs[rand.Intn(len(garageIDs))]
		plate := plates[i%len(plates)]
		customer := customers[i%len(customers)]

		// Espalhar reservas nos últimos 30 dias
		daysAgo := rand.Intn(30)
		hoursAgo := rand.Intn(12)
		entryTime := now.Add(-time.Duration(daysAgo)*24*time.Hour - time.Duration(hoursAgo)*time.Hour)
		duration := time.Duration(1+rand.Intn(8)) * time.Hour
		exitTime := entryTime.Add(duration)

		totalPrice := 30.0 + float64(rand.Intn(70)) // R$ 30~100
		currentBalance := 0.0
		totalSponsored := totalPrice
		ticketStatus := int32(3) // TICKET_SPONSORED

		// Algumas reservas parcialmente patrocinadas ou sem patrocínio
		switch {
		case i < 6: // Totalmente patrocinadas
			currentBalance = 0
			totalSponsored = totalPrice
			ticketStatus = 3 // TICKET_SPONSORED
		case i < 9: // Parcialmente patrocinadas
			totalSponsored = totalPrice * 0.6
			currentBalance = totalPrice - totalSponsored
			ticketStatus = 4 // TICKET_PARTIALLY_SPONSORED
		default: // Sem patrocínio
			totalSponsored = 0
			currentBalance = totalPrice
			ticketStatus = 1 // TICKET_CREATED
		}

		reservationStatus := int32(2) // COMPLETED
		if i < 2 {
			reservationStatus = 1 // ACTIVE (reservas ativas agora)
			exitTime = time.Time{}
		}

		resRef := client.Collection("reservations").NewDoc()
		resData := map[string]interface{}{
			"garage_id":       garageID,
			"vehicle_plate":   plate,
			"customer_name":   customer,
			"total_price":     totalPrice,
			"current_balance": currentBalance,
			"total_sponsored": totalSponsored,
			"ticket_status":   ticketStatus,
			"status":          reservationStatus,
			"entry_time":      entryTime.Unix(),
			"created_at":      entryTime.Unix(),
			"updated_at":      now.Unix(),
		}

		if !exitTime.IsZero() {
			resData["exit_time"] = exitTime.Unix()
			resData["completed_at"] = exitTime.Unix()
		}

		_, err := resRef.Set(ctx, resData)
		if err != nil {
			log.Printf("  ❌ Erro reserva %s: %v\n", plate, err)
			continue
		}
		log.Printf("  ✅ Reserva: %s | %s | R$ %.2f | Status: %d\n", plate, customer, totalPrice, ticketStatus)
		reservationIDs = append(reservationIDs, resRef.ID)

		// Criar entradas no ledger de patrocínio
		if totalSponsored > 0 {
			store := stores[rand.Intn(len(stores))]
			invoiceAmount := 200.0 + float64(rand.Intn(800)) // R$ 200~1000
			exchangeRate := totalSponsored / invoiceAmount

			ledgerRef := client.Collection("sponsorship_ledger").NewDoc()
			_, err := ledgerRef.Set(ctx, map[string]interface{}{
				"reservation_id": resRef.ID,
				"store_id":       store.ID,
				"store_name":     store.Name,
				"amount":         totalSponsored,
				"invoice_id":     fmt.Sprintf("NF-%04d", 1000+i),
				"invoice_amount": invoiceAmount,
				"timestamp":      entryTime.Add(30 * time.Minute).Unix(),
				"sync_id":        fmt.Sprintf("sync_%s_%d", store.ID, i),
				"exchange_rate":  exchangeRate,
				"operator_id":    "operador_seed",
			})
			if err != nil {
				log.Printf("  ❌ Erro ledger: %v\n", err)
			} else {
				log.Printf("    📋 Ledger: %s patrocinou R$ %.2f (NF R$ %.2f)\n", store.Name, totalSponsored, invoiceAmount)
			}

			// BI Event: sponsorship_created
			client.Collection("bi_events").NewDoc().Set(ctx, map[string]interface{}{
				"event_type":     "sponsorship_created",
				"reservation_id": resRef.ID,
				"store_id":       store.ID,
				"amount":         totalSponsored,
				"timestamp":      entryTime.Add(30 * time.Minute).Unix(),
				"source":         "seed",
			})
		}

		// Segundo patrocínio para mais 3 reservas (simulando multi-sponsor)
		if i >= 3 && i < 6 && totalSponsored > 0 {
			store2 := stores[(rand.Intn(len(stores)-1)+1)%len(stores)]
			extraAmount := 10.0 + float64(rand.Intn(20))

			ledgerRef2 := client.Collection("sponsorship_ledger").NewDoc()
			_, err := ledgerRef2.Set(ctx, map[string]interface{}{
				"reservation_id": resRef.ID,
				"store_id":       store2.ID,
				"store_name":     store2.Name,
				"amount":         extraAmount,
				"invoice_id":     fmt.Sprintf("NF-%04d-B", 1000+i),
				"invoice_amount": 250.0 + float64(rand.Intn(300)),
				"timestamp":      entryTime.Add(45 * time.Minute).Unix(),
				"sync_id":        fmt.Sprintf("sync_%s_%d_b", store2.ID, i),
				"exchange_rate":  0.05,
				"operator_id":    "operador_seed",
			})
			if err == nil {
				log.Printf("    📋 Multi-sponsor: %s +R$ %.2f\n", store2.Name, extraAmount)
			}
		}
	}

	log.Printf("  → %d reservas criadas\n", len(reservationIDs))
}

// ────────────────── Vehicle Entries ──────────────────

func seedVehicleEntries(ctx context.Context, client *firestore.Client, garageIDs []string) {
	log.Println("\n🚗 Criando entradas de veículos...")

	if len(garageIDs) == 0 {
		log.Println("  ⚠️  Nenhuma garagem encontrada, pulando vehicle entries")
		return
	}

	now := time.Now()
	plates := []string{
		"TST-0001", "TST-0002", "TST-0003", "TST-0004",
		"TST-0005", "TST-0006", "TST-0007", "TST-0008",
	}

	count := 0
	for _, garageID := range garageIDs {
		// 5~10 entradas por garagem nos últimos 7 dias
		numEntries := 5 + rand.Intn(6)

		for j := 0; j < numEntries; j++ {
			plate := plates[rand.Intn(len(plates))]
			daysAgo := rand.Intn(7)
			hoursAgo := rand.Intn(18)
			entryTime := now.Add(-time.Duration(daysAgo)*24*time.Hour - time.Duration(hoursAgo)*time.Hour)

			entryData := map[string]interface{}{
				"garage_id":     garageID,
				"vehicle_plate": plate,
				"entry_time":    entryTime.Unix(),
				"status":        int32(1), // PARKED
			}

			// Maioria já saiu
			if j > 1 || daysAgo > 0 {
				stayHours := 1 + rand.Intn(6)
				exitTime := entryTime.Add(time.Duration(stayHours) * time.Hour)
				amountPaid := 20.0 + float64(stayHours)*10.0 + float64(rand.Intn(20))

				entryData["status"] = int32(2) // EXITED
				entryData["exit_time"] = exitTime.Unix()
				entryData["amount_paid"] = amountPaid
			}

			_, err := client.Collection("vehicle_entries").NewDoc().Set(ctx, entryData)
			if err != nil {
				log.Printf("  ❌ Erro vehicle entry: %v\n", err)
			} else {
				count++
			}
		}
	}

	// BI Events para entradas/saídas
	for i := 0; i < 5; i++ {
		client.Collection("bi_events").NewDoc().Set(ctx, map[string]interface{}{
			"event_type":    "exit_confirmed",
			"garage_id":     garageIDs[rand.Intn(len(garageIDs))],
			"vehicle_plate": plates[rand.Intn(len(plates))],
			"agent_id":      "agente_seed",
			"timestamp":     now.Add(-time.Duration(rand.Intn(48)) * time.Hour).Unix(),
			"source":        "seed",
		})
	}

	log.Printf("  → %d vehicle entries criadas + 5 BI events\n", count)
}

// ────────────────── Helpers ──────────────────

func getExistingGarageIDs(ctx context.Context, client *firestore.Client) []string {
	iter := client.Collection("garages").Documents(ctx)
	var ids []string
	for {
		doc, err := iter.Next()
		if err != nil {
			break
		}
		ids = append(ids, doc.Ref.ID)
	}
	log.Printf("  📍 %d garagens encontradas no banco\n", len(ids))
	return ids
}
