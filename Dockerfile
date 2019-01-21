FROM golang:1.11-alpine

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
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
    rm -rf /var/cache/apk/*

# hadolint ignore=DL3003
RUN \
    go version && \
    go get -u -v github.com/golangci/golangci-lint/cmd/golangci-lint && \
    cd /go/src/github.com/golangci/golangci-lint && \
    git checkout v${GOLANGCI} && \
    cd /go/src/github.com/golangci/golangci-lint/cmd/golangci-lint && \
    go install -ldflags "-X 'main.version=$(git describe --tags)' -X 'main.commit=$(git rev-parse --short HEAD)' -X 'main.date=$(date)'" && \
    golangci-lint --version