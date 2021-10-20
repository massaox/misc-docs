FROM golang:1.15 as builder
COPY . /usr/local
WORKDIR /usr/local/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o cmd/app

FROM gcr.io/distroless/static
USER nonroot:nonroot
COPY --from=builder  --chown=nonroot:nonroot /usr/local/cmd/app /bin/app
ENTRYPOINT ["/bin/app"]
