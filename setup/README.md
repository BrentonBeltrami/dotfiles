# Setup basics

## Setup package manager 
### Command Line Tools
```
xcode-select --install
```

### Install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install a terminal
```
brew install kitty
```

&nbsp;
&nbsp;

# Set up dev environment.
## Github CLI
```
brew install gh
```
```
gh auth login
```

## Install my dotfiles
```
git clone https://github.com/BrentonBeltrami/dotfiles
```

## TMUX
```
brew install tmux
```

## Install Neovim
```
brew install neovim 
```

### Install LunarVim
```
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
```

## CLI utilities
```
brew install zoxide  # jump anywhere within your filesystem with z <foldername>
brew install ripgrep # blazingly fast grep
```
# Install gnu stow
brew install stow

## Install Lazygit
```
brew install lazygit
```

&nbsp;
&nbsp;

# Modify OS features 

## Replace spotlight
```
brew install raycast
```

## Window Management
```
brew install amethyst
```


<!-- 
TODO: Look into these utilities 

## CLI tools
brew install tree    # allows you to see the outline of a directory 
brew install fd      # blazingly fast find
brew install stow

## web tools
brew install insomnia # 
brew install wget
brew install httpie
brew install jq
brew install ngrok
npm -g live-server
-->
