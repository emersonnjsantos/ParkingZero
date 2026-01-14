# Build stage
FROM golang:1.25-alpine AS builder

# Instalar dependências de compilação
RUN apk add --no-cache ca-certificates git

WORKDIR /app

# Copiar todo o workspace (backend-api + pkg)
COPY backend-api/ ./backend-api/
COPY pkg/ ./pkg/

WORKDIR /app/backend-api

# Baixar dependências
RUN go mod download

# Compilar binário estático
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

# Runtime stage - imagem mínima
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /app/backend-api/server .

# Porta padrão do Cloud Run
EXPOSE 8080
ENV PORT=8080

ENTRYPOINT ["./server"]
