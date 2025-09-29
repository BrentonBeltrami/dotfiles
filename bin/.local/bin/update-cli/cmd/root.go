package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "update-cli",
	Short: "A CLI tool for daily work updates",
	Long: `A CLI tool that prompts for daily work updates Monday through Friday
and compiles them into a weekly summary on Friday.

Features:
- Daily update prompts with notifications
- Interactive markdown editing
- Weekly compilation on Fridays
- macOS notification integration`,
}

func Execute() error {
	return rootCmd.Execute()
}

func init() {
	cobra.OnInitialize(initConfig)
}

func initConfig() {
	// Configuration initialization will be handled by the config package
}

func er(msg interface{}) {
	fmt.Println("Error:", msg)
	os.Exit(1)
}