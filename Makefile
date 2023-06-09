APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ibra86dspl
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

get:
	go get

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

check:
	@echo "APP: $(APP)"
	@echo "REGISTRY: $(REGISTRY)"
	@echo "VERSION: $(VERSION)"

git_tags:
	@echo 1 $(shell git describe --tags)
	@echo 2 $(shell git tag|cat)
	@echo 3 $(shell git describe)

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/ibra86/kbot/cmd.appVersion=${VERSION}"

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot