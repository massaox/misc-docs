FROM golang:1.15 as builderstage
COPY . /usr/local
WORKDIR /usr/local/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o cmd/app

FROM ubuntu:21.04
COPY --from=builderstage /usr/local/cmd/app /bin/app
ENTRYPOINT ["/bin/app"]
