# update-cli Makefile

.PHONY: build clean install uninstall test run-setup run-edit help

# Build the application
build:
	go build -o update-cli .

# Build for release (optimized)
build-release:
	go build -ldflags="-s -w" -o update-cli .

# Clean build artifacts
clean:
	rm -f update-cli

# Install to /usr/local/bin (requires sudo)
install: build
	sudo cp update-cli /usr/local/bin/
	@echo "✅ update-cli installed to /usr/local/bin/"
	@echo "💡 Run 'update-cli setup' to get started"

# Uninstall from /usr/local/bin
uninstall:
	sudo rm -f /usr/local/bin/update-cli
	@echo "🗑️  update-cli removed from /usr/local/bin/"

# Run tests
test:
	go test ./...

# Run setup for development
run-setup: build
	./update-cli setup

# Open today's update for development
run-edit: build
	./update-cli edit

# Show usage
help:
	@echo "update-cli Makefile"
	@echo ""
	@echo "Commands:"
	@echo "  build         Build the application"
	@echo "  build-release Build optimized release version"
	@echo "  clean         Remove build artifacts"
	@echo "  install       Install to /usr/local/bin (requires sudo)"
	@echo "  uninstall     Remove from /usr/local/bin"
	@echo "  test          Run tests"
	@echo "  run-setup     Build and run setup"
	@echo "  run-edit      Build and edit today's update"
	@echo "  help          Show this help"

# Default target
all: build