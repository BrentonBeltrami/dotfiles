alias tmux='tmux -2'
# launch tmux on start
tmux attach &> /dev/null
if [[ ! $TERM =~ screen ]]; then
    exec tmux -2
fi

# source prompt file
source ~/.config/starship/prompt

# source alias files {{{
# ==============================================================================
source ~/.config/alias/vim
source ~/.config/alias/git
source ~/.config/alias/shell
# source alias files }}}
# ==============================================================================

# testing
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
export EDITOR='nvim'

#/Users/brentonbeltrami/.local/bin/poetry
export PATH="/Users/brentonbeltrami/.local/bin:$PATH"
