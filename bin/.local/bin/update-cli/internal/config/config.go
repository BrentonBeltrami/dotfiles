package config

import (
	"fmt"
	"os"
	"path/filepath"
	"time"

	"gopkg.in/yaml.v3"
)

type Config struct {
	NotificationTime string `yaml:"notification_time"`
	UpdatesDir       string `yaml:"updates_dir"`
	Template         string `yaml:"template"`
	ConfigDir        string `yaml:"-"`
}

var defaultTemplate = `# Daily Update - %s

## What I worked on today:
- 

## Blockers or challenges:
- 

## Tomorrow's priorities:
- 

## Notes:
- `

func GetConfig() (*Config, error) {
	configDir, err := getConfigDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get config directory: %w", err)
	}

	configPath := filepath.Join(configDir, "config.yaml")
	
	// Check if config exists
	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		// First run - need to run setup
		return nil, fmt.Errorf("configuration not found, please run 'update-cli setup' first")
	}

	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read config file: %w", err)
	}

	var config Config
	if err := yaml.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("failed to parse config file: %w", err)
	}

	config.ConfigDir = configDir
	return &config, nil
}

func (c *Config) Save() error {
	configPath := filepath.Join(c.ConfigDir, "config.yaml")
	
	data, err := yaml.Marshal(c)
	if err != nil {
		return fmt.Errorf("failed to marshal config: %w", err)
	}

	if err := os.MkdirAll(c.ConfigDir, 0755); err != nil {
		return fmt.Errorf("failed to create config directory: %w", err)
	}

	if err := os.WriteFile(configPath, data, 0644); err != nil {
		return fmt.Errorf("failed to write config file: %w", err)
	}

	return nil
}

func getConfigDir() (string, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(homeDir, ".config", "update-cli"), nil
}

func getDefaultUpdatesDir() (string, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(homeDir, "updates"), nil
}

func NewDefaultConfig() (*Config, error) {
	configDir, err := getConfigDir()
	if err != nil {
		return nil, err
	}

	updatesDir, err := getDefaultUpdatesDir()
	if err != nil {
		return nil, err
	}

	return &Config{
		NotificationTime: "09:00",
		UpdatesDir:       updatesDir,
		Template:         defaultTemplate,
		ConfigDir:        configDir,
	}, nil
}

func (c *Config) GetUpdatePath(date time.Time) string {
	filename := fmt.Sprintf("%s.md", date.Format("2006-01-02"))
	return filepath.Join(c.UpdatesDir, filename)
}

func (c *Config) GetWeeklyPath(weekStart time.Time) string {
	filename := fmt.Sprintf("weekly-%s.md", weekStart.Format("2006-01-02"))
	return filepath.Join(c.UpdatesDir, filename)
}

func (c *Config) EnsureUpdatesDir() error {
	return os.MkdirAll(c.UpdatesDir, 0755)
}