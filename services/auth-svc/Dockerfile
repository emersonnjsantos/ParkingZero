# Build stage
FROM golang:1.25-alpine AS builder

RUN apk add --no-cache ca-certificates git

WORKDIR /app

COPY shared/ ./shared/
COPY pkg/ ./pkg/
COPY services/auth-svc/ ./services/auth-svc/

WORKDIR /app/services/auth-svc

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .

# Runtime stage
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /app/services/auth-svc/server .

EXPOSE 50054
ENV PORT=50054

ENTRYPOINT ["./server"]
