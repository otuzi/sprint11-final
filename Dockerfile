# Этап 1: сборка приложения
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Сначала копируем файлы с зависимостями, чтобы кешировать слой с go mod download
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код и собираем статический бинарник
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /parcel-tracker .

# Этап 2: минимальный образ для запуска
FROM alpine:3.20

WORKDIR /app

# Копируем собранный бинарник и базу данных SQLite
COPY --from=builder /parcel-tracker ./parcel-tracker
COPY tracker.db ./tracker.db

CMD ["./parcel-tracker"]
