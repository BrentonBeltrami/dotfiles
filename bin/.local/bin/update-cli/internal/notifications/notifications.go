package notifications

import (
	"fmt"
	"os/exec"
	"time"
	"update-cli/internal/config"

	"github.com/charmbracelet/log"
)

func SendDailyReminder() error {
	_, err := config.GetConfig()
	if err != nil {
		return fmt.Errorf("failed to get config: %w", err)
	}

	logger := log.Default()
	logger.Info("Sending daily update reminder")

	// Check if it's a weekday (Monday-Friday)
	now := time.Now()
	if now.Weekday() == time.Saturday || now.Weekday() == time.Sunday {
		logger.Info("Skipping notification - weekend")
		return nil
	}

	// Prepare notification content
	today := now.Format("Monday, January 2")
	title := "Daily Update Reminder"
	message := fmt.Sprintf("Time for your daily update! (%s)", today)
	subtitle := "Click to open update-cli or run 'update-cli edit' in terminal"

	// Send macOS notification using osascript
	script := fmt.Sprintf(`
		display notification "%s" with title "%s" subtitle "%s" sound name "Glass"
	`, message, title, subtitle)

	cmd := exec.Command("osascript", "-e", script)
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to send notification: %w", err)
	}

	logger.Info("Notification sent successfully")
	return nil
}

func SendWeeklyCompilationNotice(weeklyFile string) error {
	logger := log.Default()
	logger.Info("Sending weekly compilation notice", "file", weeklyFile)

	title := "Weekly Summary Compiled"
	message := "Your weekly update summary has been generated!"
	subtitle := fmt.Sprintf("File: %s", weeklyFile)

	script := fmt.Sprintf(`
		display notification "%s" with title "%s" subtitle "%s" sound name "Hero"
	`, message, title, subtitle)

	cmd := exec.Command("osascript", "-e", script)
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to send compilation notice: %w", err)
	}

	logger.Info("Compilation notice sent successfully")
	return nil
}