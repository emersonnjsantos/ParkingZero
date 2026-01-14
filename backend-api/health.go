package main

import (
	"encoding/json"
	"net/http"

	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/service"
)

// HealthCheckHandler fornece endpoints de health check
type HealthCheckHandler struct {
	syncWorker *service.SyncWorker
}

// NewHealthCheckHandler cria um novo handler
func NewHealthCheckHandler(syncWorker *service.SyncWorker) *HealthCheckHandler {
	return &HealthCheckHandler{
		syncWorker: syncWorker,
	}
}

// RegisterRoutes registra as rotas de health check
func (h *HealthCheckHandler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("/health", h.Health)
	mux.HandleFunc("/health/sync", h.SyncStats)
	mux.HandleFunc("/health/ready", h.Ready)
}

// Health retorna status básico de saúde
func (h *HealthCheckHandler) Health(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":  "healthy",
		"service": "parkingzero-backend",
	})
}

// SyncStats retorna estatísticas do sync worker
func (h *HealthCheckHandler) SyncStats(w http.ResponseWriter, r *http.Request) {
	stats, err := h.syncWorker.GetSyncStats()

	w.Header().Set("Content-Type", "application/json")

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"error": err.Error(),
		})
		return
	}

	// Determinar status textual
	status := "ok"
	circuitStateText := "closed"

	switch stats.CircuitState {
	case 1: // Open
		status = "degraded"
		circuitStateText = "open"
	case 2: // Half-Open
		status = "recovering"
		circuitStateText = "half-open"
	default: // Closed
		if stats.ConsecutiveFailures > 0 {
			status = "recovering"
		}
		circuitStateText = "closed"
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":               status,
		"last_synced_at":       stats.LastSyncedAt,
		"local_total_pages":    stats.LocalTotalPages,
		"queue_size":           stats.QueueSize,
		"consecutive_failures": stats.ConsecutiveFailures,
		"circuit_state":        circuitStateText, // "closed", "open", "half-open"
		"dlq_path":             stats.DLQPath,
	})
}

// Ready retorna se o serviço está pronto para aceitar requisições
func (h *HealthCheckHandler) Ready(w http.ResponseWriter, r *http.Request) {
	stats, err := h.syncWorker.GetSyncStats()

	w.Header().Set("Content-Type", "application/json")

	if err != nil {
		w.WriteHeader(http.StatusServiceUnavailable)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"ready": false,
			"error": err.Error(),
		})
		return
	}

	// Considerar pronto apenas se circuit estiver Closed
	// Half-Open = em teste, ainda não confirmado
	ready := (stats.CircuitState == 0) // CircuitClosed

	if ready {
		w.WriteHeader(http.StatusOK)
	} else {
		w.WriteHeader(http.StatusServiceUnavailable)
	}

	circuitStateText := []string{"closed", "open", "half-open"}[stats.CircuitState]

	json.NewEncoder(w).Encode(map[string]interface{}{
		"ready":         ready,
		"circuit_state": circuitStateText,
		"failures":      stats.ConsecutiveFailures,
	})
}
