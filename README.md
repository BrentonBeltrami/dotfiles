# Introduction
## Setup package manager 
### Command Line Tools
```
xcode-select --install
```
### Install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
## Clone dotfiles
```
git clone https://github.com/BrentonBeltrami/dotfiles
```

## Dev Environment

### Homebrew Cask Packages
```bash
brew install --cask karabiner-elements
brew install --cask aerospace
brew install --cask ghostty
```

### Homebrew Packages
```bash
brew install stow
brew install tmux
brew install neovim
brew install gh
brew install lazygit
brew install ripgrep
brew install node
brew install starship
```

## Setup Tasks

### Symlinks with Stow
```bash
stow ~/.config/zsh
stow ~/.config/bin
stow ~/.config/git/
```
