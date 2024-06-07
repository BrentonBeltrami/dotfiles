alias tmux='tmux -2'
# launch tmux on start
tmux attach &> /dev/null
if [[ ! $TERM =~ screen ]]; then
    exec tmux -2
fi

source ~/.config/starship/prompt

alias ls='ls --color=auto'
alias v='nvim'
alias gs="git status"
alias view="gh pr view --web"
alias clean="kill-unnamed-sessions"
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^t "todo-toolbar\n"
bindkey -s ^n "journal\n"

function take {
    mkdir -p $1
    cd $1
}

export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
export EDITOR='nvim'

export PATH="$HOME/.local/bin:$PATH"
