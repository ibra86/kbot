# Kbot

Kbot is a CLI library for Go that empowers applications to interact with the Telegram API. This application is a tool to generate the needed files to quickly create a Cobra application.

## Getting Started

To get started with Kbot, you will need a Telegram Bot Token. You can create a bot and get a token from the [BotFather](https://t.me/BotFather).

Once you have a Telegram Bot Token, set it as an environment variable with the name `TELE_TOKEN`.

```sh
read -s TELE_TOKEN # beforehand copy to the buffer <your-telegram-bot-token>
export TELE_TOKEN
go build -ldflags "-X="github.com/ibra86/kbot/cmd.appVersion=<your-app-version>
```

## Usage

```sh
.\kbot start
```

This will start the Kbot command and connect it to your Telegram bot. Kbot will listen for messages sent to your bot and respond to them based on the specified command.

### Commands

Kbot currently supports any command with the following option:

#### `hello`

When the user sends for example `/start hello` command to the bot, Kbot will respond with a greeting message.
