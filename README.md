# Kbot

Kbot is a CLI library for Go that empowers applications to interact with the Telegram API. This application is a tool to generate the needed files to quickly create a Cobra application.

## Getting Started

Build a makefile with (default architecture arm64)
```sh
make <action> [TARGETARCH=amd64]
```


Build a dockerfile with (default architecture arm64)
```sh
TARGETOS=macos TARGETARCH=amd64 docker build --build-arg TARGETOS --build-arg TARGETARCH .
```
