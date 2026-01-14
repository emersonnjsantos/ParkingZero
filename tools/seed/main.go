// Script para popular Firestore com garagens da Ponte da Amizade
// Execute: go run tools/seed/main.go

package main

import (
	"context"
	"log"
	"os"

	firebase "firebase.google.com/go"
	"github.com/mmcloughlin/geohash"
)

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

func main() {
	ctx := context.Background()

	// Inicializar Firebase
	projectID := os.Getenv("GOOGLE_CLOUD_PROJECT")
	if projectID == "" {
		projectID = "parking-zero-app"
	}

	conf := &firebase.Config{ProjectID: projectID}
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalf("error getting Firestore client: %v\n", err)
	}
	defer client.Close()

	// Garagens da Ponte da Amizade - Foz do Iguaçu
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

	// Inserir garagens no Firestore
	for _, g := range garages {
		// Calcular geohash para busca eficiente
		g.Geohash = geohash.Encode(g.Latitude, g.Longitude)

		docRef := client.Collection("garages").NewDoc()
		_, err := docRef.Set(ctx, g)
		if err != nil {
			log.Printf("Erro ao inserir %s: %v\n", g.Name, err)
		} else {
			log.Printf("✅ Inserida: %s (ID: %s)\n", g.Name, docRef.ID)
		}
	}

	log.Println("\n🎉 Seed concluído! 5 garagens criadas na região da Ponte da Amizade.")
}
