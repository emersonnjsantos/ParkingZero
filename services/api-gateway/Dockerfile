# Build stage
FROM golang:1.25-alpine AS builder

RUN apk add --no-cache ca-certificates git

WORKDIR /app

COPY shared/ ./shared/
COPY services/api-gateway/ ./services/api-gateway/

WORKDIR /app/services/api-gateway

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

# Runtime stage
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /app/services/api-gateway/server .

EXPOSE 8080
ENV PORT=8080

ENTRYPOINT ["./server"]
