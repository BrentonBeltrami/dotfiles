package editor

import (
	"fmt"
	"os"
	"strings"
	"time"
	"update-cli/internal/config"

	"github.com/charmbracelet/bubbles/textarea"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	titleStyle = lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("#7D56F4")).
		MarginBottom(1)

	helpStyle = lipgloss.NewStyle().
		Foreground(lipgloss.Color("#626262")).
		MarginTop(1)

	successStyle = lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("#04B575"))
)

type model struct {
	textarea    textarea.Model
	date        time.Time
	config      *config.Config
	saved       bool
	err         error
	originalContent string
}

type errMsg error

func (m model) Init() tea.Cmd {
	return textarea.Blink
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.Type {
		case tea.KeyCtrlC:
			return m, tea.Quit
		case tea.KeyCtrlS:
			return m, m.save()
		case tea.KeyEsc:
			if m.hasChanges() {
				// Show unsaved changes warning
				m.err = fmt.Errorf("unsaved changes detected - press Ctrl+S to save or Ctrl+C to exit without saving")
				return m, nil
			}
			return m, tea.Quit
		}

	case errMsg:
		m.err = msg
		return m, nil

	case tea.WindowSizeMsg:
		m.textarea.SetWidth(msg.Width - 4)
		m.textarea.SetHeight(msg.Height - 6)
	}

	m.textarea, cmd = m.textarea.Update(msg)
	return m, cmd
}

func (m model) View() string {
	var b strings.Builder

	title := fmt.Sprintf("Editing Update - %s", m.date.Format("Monday, January 2, 2006"))
	b.WriteString(titleStyle.Render(title))
	b.WriteString("\n")

	b.WriteString(m.textarea.View())

	var status string
	if m.saved {
		status = successStyle.Render("✓ Saved successfully!")
	} else if m.err != nil {
		status = lipgloss.NewStyle().Foreground(lipgloss.Color("#FF6B6B")).Render(fmt.Sprintf("Error: %v", m.err))
	} else if m.hasChanges() {
		status = lipgloss.NewStyle().Foreground(lipgloss.Color("#FFA500")).Render("• Unsaved changes")
	} else {
		status = "• No changes"
	}

	help := helpStyle.Render("Ctrl+S: Save • Esc: Exit • Ctrl+C: Force Exit")

	b.WriteString("\n")
	b.WriteString(status)
	b.WriteString("\n")
	b.WriteString(help)

	return b.String()
}

func (m model) hasChanges() bool {
	return strings.TrimSpace(m.textarea.Value()) != strings.TrimSpace(m.originalContent)
}

func (m model) save() tea.Cmd {
	return func() tea.Msg {
		filepath := m.config.GetUpdatePath(m.date)
		
		// Ensure updates directory exists
		if err := m.config.EnsureUpdatesDir(); err != nil {
			return errMsg(fmt.Errorf("failed to create updates directory: %w", err))
		}

		content := strings.TrimSpace(m.textarea.Value())
		if err := os.WriteFile(filepath, []byte(content), 0644); err != nil {
			return errMsg(fmt.Errorf("failed to save file: %w", err))
		}

		// If it's Friday and we just saved, suggest compilation
		if m.date.Weekday() == time.Friday {
			// Note: We don't auto-compile to avoid complexity
			// User can run 'update-cli compile' manually
		}

		m.saved = true
		m.originalContent = content
		return nil
	}
}

func EditUpdate(date time.Time) error {
	cfg, err := config.GetConfig()
	if err != nil {
		return fmt.Errorf("failed to get configuration: %w", err)
	}

	// Load existing content or create from template
	content := ""
	filepath := cfg.GetUpdatePath(date)
	
	if data, err := os.ReadFile(filepath); err == nil {
		content = string(data)
	} else if os.IsNotExist(err) {
		// Create from template
		content = fmt.Sprintf(cfg.Template, date.Format("Monday, January 2, 2006"))
	} else {
		return fmt.Errorf("failed to read update file: %w", err)
	}

	// Create textarea
	ta := textarea.New()
	ta.SetValue(content)
	ta.Focus()
	ta.CharLimit = 0 // No limit
	ta.SetWidth(80)
	ta.SetHeight(20)

	m := model{
		textarea:        ta,
		date:            date,
		config:          cfg,
		originalContent: content,
	}

	p := tea.NewProgram(m, tea.WithAltScreen())
	
	if _, err := p.Run(); err != nil {
		return fmt.Errorf("error running editor: %w", err)
	}

	return nil
}