/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"context"
	"fmt"
	"math/rand"
	"os"
	"strings"
	"time"

	"github.com/spf13/cobra"

	"github.com/hirosassa/zerodriver"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlpmetric/otlpmetricgrpc"
	sdkmetric "go.opentelemetry.io/otel/sdk/metric"
	"go.opentelemetry.io/otel/sdk/resource"
	semconv "go.opentelemetry.io/otel/semconv/v1.12.0"

	// "go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	// "go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
	// "go.opentelemetry.io/otel/propagation"
	// sdktrace "go.opentelemetry.io/otel/sdk/trace"
	// "google.golang.org/grpc"

	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
	OtelHost  = os.Getenv("OTEL_HOST")
)

func initMetrics(ctx context.Context) {

	metricExp, _ := otlpmetricgrpc.New(
		ctx,
		otlpmetricgrpc.WithInsecure(),
		otlpmetricgrpc.WithEndpoint(OtelHost),
	)

	resource := resource.NewWithAttributes(
		semconv.SchemaURL,
		semconv.ServiceNameKey.String(fmt.Sprintf("kbot_%s", appVersion)),
	)

	meterProvider := sdkmetric.NewMeterProvider(
		sdkmetric.WithResource(resource),
		sdkmetric.WithReader(
			sdkmetric.NewPeriodicReader(
				metricExp,
				sdkmetric.WithInterval(10*time.Second)), // collects and exports metric data every 10 seconds.
		),
	)

	// Set the global MeterProvider to the newly created MeterProvider
	otel.SetMeterProvider(meterProvider)

	// traceClient := otlptracegrpc.NewClient(
	// 	otlptracegrpc.WithInsecure(),
	// 	otlptracegrpc.WithEndpoint(OtelHost),
	// 	otlptracegrpc.WithDialOption(grpc.WithBlock()))
	// sctx, cancel := context.WithTimeout(ctx, time.Second)
	// defer cancel()
	// traceExp, _ := otlptrace.New(sctx, traceClient)

	// bsp := sdktrace.NewBatchSpanProcessor(traceExp)
	// tracerProvider := sdktrace.NewTracerProvider(
	// 	sdktrace.WithSampler(sdktrace.AlwaysSample()),
	// 	sdktrace.WithResource(resource),
	// 	sdktrace.WithSpanProcessor(bsp),
	// )

	// // set global propagator to tracecontext (the default is no-op).
	// otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{}))
	// otel.SetTracerProvider(tracerProvider)

}

func pmetrics(ctx context.Context, payload string) {
	meter := otel.GetMeterProvider().Meter("kbot_command_counter")
	counter, _ := meter.Int64Counter(fmt.Sprintf("kbot_comand_%s", payload))
	// Add a value of 1 to the Int64Counter
	counter.Add(ctx, 1)

	logger := zerodriver.NewProductionLogger()
	logger.Info().Str("Version", appVersion).Msg(fmt.Sprintf("add pmetrics event: %s", payload))
}

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

		logger := zerodriver.NewProductionLogger()

		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			logger.Fatal().Str("Error", err.Error()).Msg("Please check TELE_TOKEN env variable.")
			return
		} else {
			logger.Info().Str("Version", appVersion).Msg("kbot started")

		}

		kbot.Handle(telebot.OnText, func(c telebot.Context) error {

			command := "/get"

			inputText := c.Text()
			payload := c.Message().Payload

			logger.Info().Str("Version", appVersion).Msg(fmt.Sprintf("payload: %s, text: %s\n", payload, inputText))

			if !strings.HasPrefix(inputText, command) {
				payload = "errorCommand"
				pmetrics(context.Background(), payload)
				err = c.Send("Usage: \n/get hello|time|number")
				return err
			}

			switch payload {
			case "":
				payload = "nullPayload"
				err = c.Send("Usage: \n/get hello|time|number")
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

			pmetrics(context.Background(), payload)

			return err
		})

		kbot.Start()

	},
}

func init() {
	ctx := context.Background()
	initMetrics(ctx)
	rootCmd.AddCommand(kbotCmd)
}
