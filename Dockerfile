FROM golang:1.11-alpine

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
ENV GO111MODULE=on
ENV GOLANGCI=1.13
ENV TIME_ZONE=Europe/Moscow

RUN \
    apk add --no-cache --update \
        tzdata=2018f-r0 \
        git=2.18.1-r0 \
        bash=4.4.19-r1 \
        curl=7.61.1-r1 \
    && \
    cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    rm -rf /var/cache/apk/* && \
    curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b "$(go env GOPATH)/bin" "v${GOLANGCI}" && \
    go version && \
    golangci-lint --version