package compiler

import (
	"fmt"
	"os"
	"strings"
	"time"
	"update-cli/internal/config"

	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/log"
)

var (
	headerStyle = lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("#7D56F4"))

	dateStyle = lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("#04B575"))

	missingStyle = lipgloss.NewStyle().
		Italic(true).
		Foreground(lipgloss.Color("#999999"))
)

func CompileWeek(weekStart time.Time) (string, error) {
	cfg, err := config.GetConfig()
	if err != nil {
		return "", fmt.Errorf("failed to get configuration: %w", err)
	}

	logger := log.NewWithOptions(os.Stderr, log.Options{
		ReportTimestamp: false,
		ReportCaller:    false,
		Prefix:          "📝 ",
	})

	logger.Info("Compiling weekly summary", "week_start", weekStart.Format("2006-01-02"))

	// Ensure it's a Monday
	if weekStart.Weekday() != time.Monday {
		return "", fmt.Errorf("week start must be a Monday, got %s", weekStart.Weekday())
	}

	var content strings.Builder

	// Header
	weekEnd := weekStart.AddDate(0, 0, 4) // Friday
	title := fmt.Sprintf("# Weekly Summary: %s - %s", 
		weekStart.Format("January 2"), 
		weekEnd.Format("January 2, 2006"))
	content.WriteString(title)
	content.WriteString("\n\n")

	// Table of contents
	content.WriteString("## Overview\n\n")

	var weekdays = []time.Weekday{
		time.Monday, time.Tuesday, time.Wednesday, time.Thursday, time.Friday,
	}
	var dayNames = []string{
		"Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
	}

	availableDays := 0
	for i, weekday := range weekdays {
		date := weekStart.AddDate(0, 0, int(weekday)-1)
		filepath := cfg.GetUpdatePath(date)
		
		if _, err := os.Stat(filepath); err == nil {
			availableDays++
			content.WriteString(fmt.Sprintf("- ✅ %s (%s)\n", dayNames[i], date.Format("Jan 2")))
		} else {
			content.WriteString(fmt.Sprintf("- ❌ %s (%s) - No update\n", dayNames[i], date.Format("Jan 2")))
		}
	}

	content.WriteString(fmt.Sprintf("\n**Updates completed:** %d/5 days\n\n", availableDays))
	content.WriteString("---\n\n")

	// Daily sections
	for i, weekday := range weekdays {
		date := weekStart.AddDate(0, 0, int(weekday)-1)
		filepath := cfg.GetUpdatePath(date)

		dayHeader := fmt.Sprintf("## %s - %s", dayNames[i], date.Format("January 2, 2006"))
		content.WriteString(dayHeader)
		content.WriteString("\n\n")

		if data, err := os.ReadFile(filepath); err == nil {
			dayContent := string(data)
			
			// Remove the title from the daily update if it exists
			lines := strings.Split(dayContent, "\n")
			var filteredLines []string
			
			for _, line := range lines {
				// Skip lines that look like daily update titles
				if strings.HasPrefix(line, "# Daily Update") {
					continue
				}
				filteredLines = append(filteredLines, line)
			}
			
			cleanContent := strings.TrimSpace(strings.Join(filteredLines, "\n"))
			if cleanContent != "" {
				content.WriteString(cleanContent)
			} else {
				content.WriteString("*No content*")
			}
		} else {
			content.WriteString("*No update recorded for this day*")
		}

		content.WriteString("\n\n")
		
		// Add separator except for the last day
		if i < len(weekdays)-1 {
			content.WriteString("---\n\n")
		}
	}

	// Footer
	content.WriteString("---\n\n")
	content.WriteString(fmt.Sprintf("*Generated on %s by update-cli*\n", time.Now().Format("January 2, 2006 at 3:04 PM")))

	// Write the compiled file
	weeklyPath := cfg.GetWeeklyPath(weekStart)
	if err := cfg.EnsureUpdatesDir(); err != nil {
		return "", fmt.Errorf("failed to ensure updates directory: %w", err)
	}

	if err := os.WriteFile(weeklyPath, []byte(content.String()), 0644); err != nil {
		return "", fmt.Errorf("failed to write weekly summary: %w", err)
	}

	logger.Info("Weekly summary compiled successfully", "file", weeklyPath, "days_included", availableDays)

	return weeklyPath, nil
}

// CompileCurrentWeek compiles the current week's updates
func CompileCurrentWeek() (string, error) {
	now := time.Now()
	// Find the Monday of current week
	weekStart := now.AddDate(0, 0, -int(now.Weekday())+1)
	return CompileWeek(weekStart)
}