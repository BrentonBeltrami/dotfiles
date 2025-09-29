package cmd

import (
	"fmt"
	"update-cli/internal/config"

	"github.com/spf13/cobra"
)

var setupCmd = &cobra.Command{
	Use:   "setup",
	Short: "Run the initial setup or reconfigure settings",
	Long:  `Configure notification times, templates, and other settings.`,
	Run: func(cmd *cobra.Command, args []string) {
		if err := config.RunSetup(); err != nil {
			fmt.Printf("Setup failed: %v\n", err)
			return
		}
		fmt.Println("Setup completed successfully!")
	},
}

func init() {
	rootCmd.AddCommand(setupCmd)
}