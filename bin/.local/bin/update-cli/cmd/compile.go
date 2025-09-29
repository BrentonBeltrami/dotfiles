package cmd

import (
	"fmt"
	"time"
	"update-cli/internal/compiler"

	"github.com/spf13/cobra"
)

var compileCmd = &cobra.Command{
	Use:   "compile [week-start-date]",
	Short: "Compile weekly summary",
	Long: `Compile all daily updates from the current week (Monday-Friday) into a weekly summary.
If a date is provided, compile the week starting from that Monday.`,
	Args: cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		var weekStart time.Time
		var err error

		if len(args) == 0 {
			now := time.Now()
			// Find the Monday of current week
			weekStart = now.AddDate(0, 0, -int(now.Weekday())+1)
		} else {
			weekStart, err = time.Parse("2006-01-02", args[0])
			if err != nil {
				fmt.Printf("Invalid date format. Use YYYY-MM-DD: %v\n", err)
				return
			}
			// Ensure it's a Monday
			if weekStart.Weekday() != time.Monday {
				fmt.Println("Date must be a Monday")
				return
			}
		}

		filename, err := compiler.CompileWeek(weekStart)
		if err != nil {
			fmt.Printf("Failed to compile weekly summary: %v\n", err)
			return
		}

		fmt.Printf("Weekly summary compiled: %s\n", filename)
	},
}

func init() {
	rootCmd.AddCommand(compileCmd)
}