APP=$(shell basename $(shell git remote get-url origin) | sed 's/\.git$$//')
REGISTRY=ghcr.io/ibra86#ibra86dspl #ghcr.io/ibra86 
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux# darwin windows
TARGETARCH=amd64# ard64

get:
	go get

format:
	gofmt -s -w ./

lint:
	staticcheck

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/ibra86/kbot/cmd.appVersion=${VERSION}"

start: build
	./kbot start

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot