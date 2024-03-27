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
## Install dotfiles
```
git clone https://github.com/BrentonBeltrami/dotfiles
```
## Install & Run ansible
```
brew install ansible
```
```
ansible-playbook ~/.config/setup/setup.yml
```

## Log into gh
```
gh auth login
```
## Setup yabai
[Follow this guide from yabai](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
