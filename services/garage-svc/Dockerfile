# Build stage
FROM golang:1.25-alpine AS builder

RUN apk add --no-cache ca-certificates git

WORKDIR /app

# Copiar workspace completo (shared + pkg + service)
COPY shared/ ./shared/
COPY pkg/ ./pkg/
COPY services/garage-svc/ ./services/garage-svc/

WORKDIR /app/services/garage-svc

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

# Runtime stage
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /app/services/garage-svc/server .

EXPOSE 50051
ENV PORT=50051

ENTRYPOINT ["./server"]
