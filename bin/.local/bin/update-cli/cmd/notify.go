package cmd

import (
	"fmt"
	"update-cli/internal/notifications"

	"github.com/spf13/cobra"
)

var notifyCmd = &cobra.Command{
	Use:   "notify",
	Short: "Send a notification reminder (used by scheduler)",
	Long:  `Send a macOS notification to remind about daily updates. This command is typically called by the scheduler.`,
	Run: func(cmd *cobra.Command, args []string) {
		if err := notifications.SendDailyReminder(); err != nil {
			fmt.Printf("Failed to send notification: %v\n", err)
			return
		}
	},
}

func init() {
	rootCmd.AddCommand(notifyCmd)
}