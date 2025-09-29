package cmd

import (
	"fmt"
	"time"
	"update-cli/internal/editor"

	"github.com/spf13/cobra"
)

var editCmd = &cobra.Command{
	Use:   "edit [date]",
	Short: "Edit today's update or a specific date",
	Long: `Open the daily update for editing. If no date is provided, 
opens today's update. Date should be in YYYY-MM-DD format.`,
	Args: cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		var date time.Time
		var err error

		if len(args) == 0 {
			date = time.Now()
		} else {
			date, err = time.Parse("2006-01-02", args[0])
			if err != nil {
				fmt.Printf("Invalid date format. Use YYYY-MM-DD: %v\n", err)
				return
			}
		}

		if err := editor.EditUpdate(date); err != nil {
			fmt.Printf("Error editing update: %v\n", err)
			return
		}
	},
}

func init() {
	rootCmd.AddCommand(editCmd)
}