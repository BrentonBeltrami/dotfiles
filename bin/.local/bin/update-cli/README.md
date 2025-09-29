# update-cli

A beautiful CLI tool for daily work updates with automatic weekly compilation and macOS notifications.

## Features

- 📝 **Interactive daily updates** using Bubble Tea TUI
- 📅 **Automatic weekly compilation** every Friday
- 🔔 **macOS notifications** with customizable timing
- ⚙️ **Easy configuration** with first-run setup
- 🎨 **Beautiful terminal interface** powered by Charm tools

## Installation

```bash
# Build from source
go build -o update-cli .

# Move to PATH (optional)
sudo mv update-cli /usr/local/bin/
```

## Quick Start

1. **Initial Setup**
   ```bash
   ./update-cli setup
   ```
   This will guide you through configuring:
   - Updates directory (default: `~/updates/`)
   - Daily notification time
   - Custom markdown template (optional)

2. **Enable Daily Notifications**
   ```bash
   ./update-cli schedule
   ```

3. **Create Your First Update**
   ```bash
   ./update-cli edit
   ```

## Commands

### `update-cli edit [date]`
Open the daily update editor. If no date is provided, opens today's update.

**Examples:**
```bash
update-cli edit                # Edit today's update
update-cli edit 2024-01-15    # Edit specific date
```

### `update-cli setup`
Run initial configuration or modify existing settings.

### `update-cli compile [week-start-date]`
Compile weekly summary from Monday-Friday updates.

**Examples:**
```bash
update-cli compile            # Compile current week
update-cli compile 2024-01-08 # Compile specific week (must be Monday)
```

### `update-cli schedule`
Install daily notification schedule using macOS launchd.

### `update-cli unschedule`
Remove daily notification schedule.

### `update-cli notify`
Send notification manually (used internally by scheduler).

## File Structure

Updates are stored as markdown files:

```
~/updates/
├── 2024-01-08.md              # Monday update
├── 2024-01-09.md              # Tuesday update
├── 2024-01-10.md              # Wednesday update
├── 2024-01-11.md              # Thursday update
├── 2024-01-12.md              # Friday update
└── weekly-2024-01-08.md       # Weekly summary
```

## Configuration

Configuration is stored in `~/.config/update-cli/config.yaml`:

```yaml
notification_time: "09:00"
updates_dir: "/Users/yourusername/updates"
template: |
  # Daily Update - %s

  ## What I worked on today:
  - 

  ## Blockers or challenges:
  - 

  ## Tomorrow's priorities:
  - 

  ## Notes:
  - 
```

## Default Template

The default daily update template includes:
- What you worked on today
- Blockers or challenges
- Tomorrow's priorities  
- Additional notes

You can customize this template during setup or by editing the config file.

## Weekly Compilation

On Fridays, after editing your daily update, you can run `update-cli compile` to generate a weekly summary that includes:
- Overview of completed days
- All daily updates organized by day
- Automatic formatting and timestamps

## Notifications

Daily reminders are sent Monday through Friday at your configured time using macOS native notifications. The notification includes:
- Reminder to complete your daily update
- Current date
- Quick action to open the CLI

## Requirements

- macOS (for notifications and launchd scheduling)
- Go 1.21+ (for building from source)

## Built With

- [Charm](https://charm.land/) ecosystem:
  - **Bubble Tea** - Interactive TUI framework
  - **Huh** - Terminal forms and prompts
  - **Lipgloss** - Terminal styling
  - **Log** - Structured logging
- [Cobra](https://cobra.dev/) - CLI framework
- [YAML](https://gopkg.in/yaml.v3) - Configuration format

## License

MIT License - see LICENSE file for details.
