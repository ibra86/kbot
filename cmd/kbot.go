/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"math/rand"
	"os"
	"strings"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	// Teletoken bot
	TeleToken = os.Getenv("TELE_TOKEN")
)

// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started. ", appVersion)
		// fmt.Printf("teletoken env var: %s. ", TeleToken)

		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(c telebot.Context) error {

			command := "/get"

			inputText := c.Text()
			payload := c.Message().Payload

			// log.Printf("message: %+v\n", c.Message())
			log.Printf("payload: %s, text: %s\n", payload, inputText)

			if !strings.HasPrefix(inputText, command) {
				err = c.Send("Usage: \n/get hello|time|number")
				return err
			}

			switch payload {
			case "hello":
				err = c.Send(fmt.Sprintf("Hello I'm Kbot %s. ", appVersion))
			case "time":
				location := time.FixedZone("GMT+3", 3*60*60)
				currentTime := time.Now().In(location)
				timeString := currentTime.Format("2006-01-02 15:04:05")
				err = c.Send(fmt.Sprintf("Time now is: %s", timeString))
			case "number":
				rand.NewSource(time.Now().UnixNano())
				randomNumber := rand.Intn(101)
				err = c.Send(fmt.Sprintf("Your random number between 0 and 100: %d", randomNumber))
			default:
				err = c.Send("Usage: \n/get hello|time|number")
			}

			return err
		})

		kbot.Start()

	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
