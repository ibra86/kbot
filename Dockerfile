FROM golang:1.19 as builder
WORKDIR /go/src/app
COPY . .
RUN make build TARGETOS=linux TARGETARCH=amd64

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot", "start"]