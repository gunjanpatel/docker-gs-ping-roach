##
## Build
##

FROM golang:1.21-bookworm AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping-roach

##
## Deploy
##

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /docker-gs-ping-roach /docker-gs-ping-roach

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/docker-gs-ping-roach"]
