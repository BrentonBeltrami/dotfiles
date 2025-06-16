# alias tmux='tmux -2'
# # launch tmux on start
# tmux attach &> /dev/null
# if [[ ! $TERM =~ screen ]]; then
#     exec tmux -2
# fi

alias advent='NVIM_APPNAME=nvim_advent nvim'


source ~/.config/starship/prompt

alias ls='ls --color=auto'
alias v='nvim'
alias gs="git status"
alias view="gh pr view --web"
alias clean="kill-unnamed-sessions"
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^t "todo-toolbar\n"
bindkey -s ^n "journal\n"
# Disable flow control
stty -ixon
bindkey -s ^q "journal --question\n"

function take {
    mkdir -p $1
    cd $1
}

export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
export EDITOR='nvim'

export PATH="$HOME/.local/bin:$PATH"
#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
# _gt_yargs_completions()
# {
#   local reply
#   local si=$IFS
#   IFS=$'
# ' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
#   IFS=$si
#   _describe 'values' reply
# }
# compdef _gt_yargs_completions gt
###-end-gt-completions-###

# Node manager fnm
eval "$(fnm env --use-on-cd)"

# Direnv
eval "$(direnv hook zsh)"

export PATH="/usr/local/opt/mysql-client/bin:$PATH"

eval "$(~/.local/bin/mise activate zsh)"

# bun completions
[ -s "/Users/brentonbeltrami/.bun/_bun" ] && source "/Users/brentonbeltrami/.bun/_bun"
