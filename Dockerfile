FROM golang:1.12
RUN go get -d -v github.com/gree-gorey/bash-exporter/cmd/bash-exporter
WORKDIR /go/src/github.com/gree-gorey/bash-exporter/cmd/bash-exporter
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bash-exporter .

FROM alpine:latest

RUN addgroup -g 1000 app && adduser -h /app -u 1000 -G app -D app

USER app
WORKDIR /app
ENV PARAMS="-interval 60"

COPY --from=0 /go/src/github.com/gree-gorey/bash-exporter/cmd/bash-exporter/bash-exporter .
# COPY ./examples/* /scripts/

EXPOSE 9300

ENTRYPOINT ./bash-exporter ${PARAMS}
