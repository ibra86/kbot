APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ibra86dspl
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETARCH=arm64

get:
	go get

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/ibra86/kbot/cmd.appVersion=${VERSION}"

linux: TARGETOS=linux
linux: build

macos: TARGETOS=darwin
macos: build

windows: TARGETOS=windows
windows: build

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}