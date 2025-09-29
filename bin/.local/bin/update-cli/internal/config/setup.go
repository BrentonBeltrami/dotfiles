package config

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/charmbracelet/huh"
)

func RunSetup() error {
	fmt.Println("🚀 Welcome to update-cli setup!")
	fmt.Println()

	config, err := NewDefaultConfig()
	if err != nil {
		return fmt.Errorf("failed to create default config: %w", err)
	}

	// Check if config already exists
	existingConfig, _ := GetConfig()
	if existingConfig != nil {
		config = existingConfig
		fmt.Println("📝 Existing configuration found, you can modify the settings below.")
		fmt.Println()
	}

	var (
		notificationHour   string = "9"
		notificationMinute string = "0"
		updatesDir         string = config.UpdatesDir
		useCustomTemplate  bool   = false
		customTemplate     string
	)

	// Parse existing notification time
	if config.NotificationTime != "" {
		parts := strings.Split(config.NotificationTime, ":")
		if len(parts) == 2 {
			notificationHour = parts[0]
			notificationMinute = parts[1]
		}
	}

	form := huh.NewForm(
		huh.NewGroup(
			huh.NewInput().
				Title("Updates Directory").
				Description("Where should daily update files be stored?").
				Value(&updatesDir).
				Placeholder(config.UpdatesDir),

			huh.NewInput().
				Title("Notification Hour (0-23)").
				Description("What hour should daily reminders be sent?").
				Value(&notificationHour).
				Validate(func(s string) error {
					if i, err := strconv.Atoi(s); err != nil {
						return fmt.Errorf("must be a number")
					} else if i < 0 || i > 23 {
						return fmt.Errorf("hour must be between 0 and 23")
					}
					return nil
				}),

			huh.NewInput().
				Title("Notification Minute (0-59)").
				Description("What minute of the hour should reminders be sent?").
				Value(&notificationMinute).
				Validate(func(s string) error {
					if i, err := strconv.Atoi(s); err != nil {
						return fmt.Errorf("must be a number")
					} else if i < 0 || i > 59 {
						return fmt.Errorf("minute must be between 0 and 59")
					}
					return nil
				}),

			huh.NewConfirm().
				Title("Custom Template").
				Description("Would you like to customize the daily update template?").
				Value(&useCustomTemplate),
		),
	)

	if err := form.Run(); err != nil {
		return fmt.Errorf("setup cancelled: %w", err)
	}

	// Handle custom template
	if useCustomTemplate {
		templateForm := huh.NewForm(
			huh.NewGroup(
				huh.NewText().
					Title("Custom Template").
					Description("Enter your custom daily update template (use %s for date placeholder):").
					Value(&customTemplate).
					Placeholder(config.Template),
			),
		)

		if err := templateForm.Run(); err != nil {
			return fmt.Errorf("template setup cancelled: %w", err)
		}

		if strings.TrimSpace(customTemplate) != "" {
			config.Template = customTemplate
		}
	}

	// Parse and update config
	hour, _ := strconv.Atoi(notificationHour)
	minute, _ := strconv.Atoi(notificationMinute)
	
	config.UpdatesDir = updatesDir
	config.NotificationTime = fmt.Sprintf("%02d:%02d", hour, minute)

	// Save config
	if err := config.Save(); err != nil {
		return fmt.Errorf("failed to save configuration: %w", err)
	}

	// Ensure updates directory exists
	if err := config.EnsureUpdatesDir(); err != nil {
		return fmt.Errorf("failed to create updates directory: %w", err)
	}

	fmt.Printf("\n✅ Configuration saved successfully!\n")
	fmt.Printf("   📂 Updates directory: %s\n", config.UpdatesDir)
	fmt.Printf("   ⏰ Daily reminder: %s\n", config.NotificationTime)
	fmt.Printf("\n💡 Next steps:\n")
	fmt.Printf("   • Run 'update-cli edit' to create your first update\n")
	fmt.Printf("   • Run 'update-cli schedule' to enable daily notifications\n")

	return nil
}