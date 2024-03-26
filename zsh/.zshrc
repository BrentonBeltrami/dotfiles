alias tmux='tmux -2'
# launch tmux on start
tmux attach &> /dev/null
if [[ ! $TERM =~ screen ]]; then
    exec tmux -2
fi

bindkey -s ^b "log.sh\n"
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^w "cht.sh\n"

# source prompt file
source ~/.config/starship/prompt

# source alias files {{{
# ==============================================================================
source ~/.config/alias/vim
source ~/.config/alias/git
source ~/.config/alias/tmux
source ~/.config/alias/shell
source ~/.config/alias/react
# source alias files }}}
# ==============================================================================

# quicly edit config files
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.vim'


# testing
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
export EDITOR='nvim'


#/Users/brentonbeltrami/.local/bin/poetry
export PATH="/Users/brentonbeltrami/.local/bin:$PATH"

# bun completions
[ -s "/Users/brentonbeltrami/.bun/_bun" ] && source "/Users/brentonbeltrami/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
