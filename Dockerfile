FROM golang:1.18

WORKDIR /cristian_test

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o /build/cristian_test.go cmd/app/main.go

EXPOSE 80

CMD [ "/build/cristian_test.go" ]