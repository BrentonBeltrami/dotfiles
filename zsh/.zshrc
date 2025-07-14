source ~/.config/starship/prompt
export EDITOR='nvim'

alias ls='ls --color=auto'
alias v='nvim'
alias gs="git status"
alias view='branch=$(git branch --show-current); if [[ "$branch" == "main" || "$branch" == "master" ]]; then gh repo view --web; else gh pr view --web; fi'
alias clean="kill-unnamed-sessions"
#
# Tools
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^n "journal\n"
bindkey -s ^q "journal --question\n"

# Disable flow control
stty -ixon

export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"

export PATH="$HOME/.local/bin:$PATH"

# Node manager fnm
eval "$(fnm env --use-on-cd)"

# Direnv
eval "$(direnv hook zsh)"

# bun completions
[ -s "/Users/brentonbeltrami/.bun/_bun" ] && source "/Users/brentonbeltrami/.bun/_bun"
