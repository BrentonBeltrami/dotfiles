alias tmux='tmux -2'
# launch tmux on start
tmux attach &> /dev/null
if [[ ! $TERM =~ screen ]]; then
    exec tmux -2
fi
#[[ $- != *i* ]] && return
#[[ $TERM != screen* ]] && exec tmux -2
#export TERM=xterm-256color


# source prompt file
source ~/.config/zshell/prompt

# source alias files {{{
# ==============================================================================
alias help="more ~/.config/zshell/help"

source ~/.config/zshell/alias/vim
source ~/.config/zshell/alias/git
source ~/.config/zshell/alias/tmux
source ~/.config/zshell/alias/shell
source ~/.config/zshell/alias/react

# source project jumps
source ~/.config/zshell/alias/project
alias aproject="more ~/.config/zshell/alias/project"
# source alias files }}}
# ==============================================================================

# quicly edit config files
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.vim'


# testing
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
