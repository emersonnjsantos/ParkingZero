# Build stage
FROM golang:1.25-alpine AS builder

# Instalar dependências de compilação
RUN apk add --no-cache ca-certificates git

WORKDIR /app

# Copiar arquivos de módulos (cacheável)
COPY go.mod go.sum ./
RUN go mod download

# Copiar código fonte
COPY . .

# Compilar binário estático
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

# Runtime stage - imagem mínima
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /app/server .

# Porta padrão do Cloud Run
EXPOSE 8080
ENV PORT=8080

ENTRYPOINT ["./server"]
