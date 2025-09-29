package cmd

import (
	"fmt"
	"update-cli/internal/config"

	"github.com/spf13/cobra"
)

var scheduleCmd = &cobra.Command{
	Use:   "schedule",
	Short: "Install or update the notification schedule",
	Long: `Install or update the launchd plist file for daily notification scheduling.
This sets up automatic daily reminders based on your configured time.`,
	Run: func(cmd *cobra.Command, args []string) {
		if err := config.InstallSchedule(); err != nil {
			fmt.Printf("Failed to install schedule: %v\n", err)
			return
		}
		fmt.Println("Notification schedule installed successfully!")
	},
}

var unscheduleCmd = &cobra.Command{
	Use:   "unschedule",
	Short: "Remove the notification schedule",
	Long:  `Remove the launchd plist file to stop automatic daily notifications.`,
	Run: func(cmd *cobra.Command, args []string) {
		if err := config.UninstallSchedule(); err != nil {
			fmt.Printf("Failed to remove schedule: %v\n", err)
			return
		}
		fmt.Println("Notification schedule removed successfully!")
	},
}

func init() {
	rootCmd.AddCommand(scheduleCmd)
	rootCmd.AddCommand(unscheduleCmd)
}