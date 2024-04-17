FROM golang:1.21-alpine as builder

WORKDIR /app

# build the main app
COPY . .
RUN go get \
&& go mod vendor \
&& CGO_ENABLED=0 GOOS=linux go build -o /app/bin/main -a -v /app/main.go
CMD ["./bin/main"]

FROM scratch
COPY --from=builder /app/bin/main /bin/main
COPY --from=builder /app/config /config
ENTRYPOINT ["/bin/main"]