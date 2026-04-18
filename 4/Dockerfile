FROM golang:1.25-alpine3.22 AS builder

WORKDIR /app

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

COPY go.mod go.sum ./
RUN go mod download -x

COPY . .

RUN go build -trimpath -ldflags="-s -w" -o myapp .

FROM alpine:3.22

WORKDIR /app

RUN addgroup -S appuser \
 && adduser -S -G appuser -H -s /sbin/nologin appuser

COPY --from=builder --chown=appuser:appuser /app/myapp /app/myapp

RUN chown appuser /app

USER appuser

ENTRYPOINT ["/app/myapp"]
