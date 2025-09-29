package config

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"text/template"
)

const launchAgentTemplate = `<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.update-cli</string>
    <key>ProgramArguments</key>
    <array>
        <string>{{.ExecutablePath}}</string>
        <string>notify</string>
    </array>
    <key>StartCalendarInterval</key>
    <array>
        <dict>
            <key>Weekday</key>
            <integer>1</integer>
            <key>Hour</key>
            <integer>{{.Hour}}</integer>
            <key>Minute</key>
            <integer>{{.Minute}}</integer>
        </dict>
        <dict>
            <key>Weekday</key>
            <integer>2</integer>
            <key>Hour</key>
            <integer>{{.Hour}}</integer>
            <key>Minute</key>
            <integer>{{.Minute}}</integer>
        </dict>
        <dict>
            <key>Weekday</key>
            <integer>3</integer>
            <key>Hour</key>
            <integer>{{.Hour}}</integer>
            <key>Minute</key>
            <integer>{{.Minute}}</integer>
        </dict>
        <dict>
            <key>Weekday</key>
            <integer>4</integer>
            <key>Hour</key>
            <integer>{{.Hour}}</integer>
            <key>Minute</key>
            <integer>{{.Minute}}</integer>
        </dict>
        <dict>
            <key>Weekday</key>
            <integer>5</integer>
            <key>Hour</key>
            <integer>{{.Hour}}</integer>
            <key>Minute</key>
            <integer>{{.Minute}}</integer>
        </dict>
    </array>
    <key>StandardOutPath</key>
    <string>/tmp/update-cli.out</string>
    <key>StandardErrorPath</key>
    <string>/tmp/update-cli.err</string>
</dict>
</plist>`

type LaunchAgentData struct {
	ExecutablePath string
	Hour           int
	Minute         int
}

func InstallSchedule() error {
	config, err := GetConfig()
	if err != nil {
		return fmt.Errorf("failed to get config: %w", err)
	}

	// Parse notification time
	var hour, minute int
	if _, err := fmt.Sscanf(config.NotificationTime, "%d:%d", &hour, &minute); err != nil {
		return fmt.Errorf("invalid notification time format: %w", err)
	}

	// Get executable path
	execPath, err := os.Executable()
	if err != nil {
		return fmt.Errorf("failed to get executable path: %w", err)
	}

	// Get LaunchAgents directory
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("failed to get home directory: %w", err)
	}

	launchAgentsDir := filepath.Join(homeDir, "Library", "LaunchAgents")
	if err := os.MkdirAll(launchAgentsDir, 0755); err != nil {
		return fmt.Errorf("failed to create LaunchAgents directory: %w", err)
	}

	plistPath := filepath.Join(launchAgentsDir, "com.user.update-cli.plist")

	// Generate plist content
	tmpl, err := template.New("launchagent").Parse(launchAgentTemplate)
	if err != nil {
		return fmt.Errorf("failed to parse template: %w", err)
	}

	var plistContent strings.Builder
	data := LaunchAgentData{
		ExecutablePath: execPath,
		Hour:           hour,
		Minute:         minute,
	}

	if err := tmpl.Execute(&plistContent, data); err != nil {
		return fmt.Errorf("failed to execute template: %w", err)
	}

	// Write plist file
	if err := os.WriteFile(plistPath, []byte(plistContent.String()), 0644); err != nil {
		return fmt.Errorf("failed to write plist file: %w", err)
	}

	// Load the launch agent
	cmd := exec.Command("launchctl", "load", plistPath)
	if err := cmd.Run(); err != nil {
		// Try to unload first in case it's already loaded
		unloadCmd := exec.Command("launchctl", "unload", plistPath)
		unloadCmd.Run() // Ignore error

		// Try loading again
		if err := cmd.Run(); err != nil {
			return fmt.Errorf("failed to load launch agent: %w", err)
		}
	}

	fmt.Printf("✅ Schedule installed successfully!\n")
	fmt.Printf("   📅 Daily notifications will be sent at %s, Monday-Friday\n", config.NotificationTime)
	fmt.Printf("   📁 Launch agent: %s\n", plistPath)

	return nil
}

func UninstallSchedule() error {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("failed to get home directory: %w", err)
	}

	plistPath := filepath.Join(homeDir, "Library", "LaunchAgents", "com.user.update-cli.plist")

	// Unload the launch agent
	cmd := exec.Command("launchctl", "unload", plistPath)
	if err := cmd.Run(); err != nil {
		// Don't fail if it's not loaded
		fmt.Println("⚠️  Launch agent was not loaded (this is normal if not previously scheduled)")
	}

	// Remove the plist file
	if err := os.Remove(plistPath); err != nil {
		if os.IsNotExist(err) {
			return fmt.Errorf("schedule not found")
		}
		return fmt.Errorf("failed to remove plist file: %w", err)
	}

	fmt.Println("✅ Schedule removed successfully!")
	return nil
}