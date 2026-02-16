# Build stage
FROM golang:1.25-alpine AS builder

RUN apk add --no-cache ca-certificates git

WORKDIR /app

# Copiar workspace (shared + pkg + service)
COPY shared/ ./shared/
COPY pkg/ ./pkg/
COPY services/vehicle-svc/ ./services/vehicle-svc/

WORKDIR /app/services/vehicle-svc

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

# Runtime stage
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /app/services/vehicle-svc/server .

# Criar diretório para banco local
RUN mkdir -p /data

EXPOSE 50052
ENV PORT=50052
ENV LOCAL_DB_PATH=/data/parkingzero.db

ENTRYPOINT ["./server"]
