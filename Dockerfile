FROM golang:1.25 AS base

WORKDIR /app

# Dependencies are stored in go.mod file
COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o main .

# Distroless image stage
FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]