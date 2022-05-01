"
" -----------------------------------------------------------------------------
" STYLING
" -----------------------------------------------------------------------------
syntax on "turn on syntax highlighting
set background=dark "set background to dark
set number relativenumber "set relative number
" 'default line number is too distractive' - Montana
hi clear LineNr
hi link LineNr Comment
hi link OverLength Error
set cursorline "set row line for cursor
set tabstop=2 "reduce indentation
set shiftwidth=2
set hidden
set nowrap
set list
set showmatch
set title
set listchars=tab:\ \ ,trail:·

" COLORS
set termguicolors
set signcolumn=yes:1
"hi NonText ctermfg=16 guifg=#61E8E1
hi NonText guifg=#61E8E1
hi EndOfBuffer guifg=bg
hi CursorLine cterm=underline
hi Pmenu cterm=underline guifg=bg guibg=fg
hi PmenuSel guibg=LightGray guifg=Black
hi SignColumn guibg=bg ctermbg=white

" -----------------------------------------------------------------------------
" FUNCTIONALITY
" -----------------------------------------------------------------------------
let mapleader = " " "set leader to space
"allow :W to act as :w in vim command line
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
" Quicker switching between windows
nmap <silent> <C-h> <C-w>h
nmap <silent> <C-j> <C-w>j
nmap <silent> <C-k> <C-w>k
nmap <silent> <C-l> <C-w>l
" Change operations go to blackhole register
nnoremap c "_c
nnoremap C "_C
" Backspace switches to last buffer
nnoremap <Backspace> <C-^>

"REMAPPINGS
"access system clipboard
nnoremap "" "*
"remove 'v' from entering visual mode
noremap v <Nop>
"leader + n is now depreceated in favor for leader + ff
nnoremap <leader>n <cmd>:cho "Use space + ff"<cr>
"toggle relativenumber
nmap <leader>p :set rnu!<cr>
cmap Gdiff Gdiffsplit!


" -----------------------------------------------------------------------------
"PLUGINS
" -----------------------------------------------------------------------------
call plug#begin(stdpath('data') . '/plugged')

"functional plugins
	Plug 'preservim/nerdtree'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'airblade/vim-rooter'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-fugitive'
	Plug 'machakann/vim-highlightedyank'
	Plug 'rmagatti/alternate-toggler'

"Styling plugins
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'folke/todo-comments.nvim'

"Webdev plugins
	Plug 'pangloss/vim-javascript'
	Plug 'mxw/vim-jsx'
	Plug 'leafgarland/typescript-vim'
	Plug 'prettier/vim-prettier', { 'do': 'npm install' }
	Plug 'mattn/emmet-vim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'neoclide/coc-eslint'
	Plug 'rodrigore/coc-tailwind-intellisense', {'do': 'npm install'}

"Prose
	Plug 'lervag/wiki.vim'
	Plug 'folke/zen-mode.nvim'

"Testing
Plug 'joshdick/onedark.vim'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'sudormrfbin/cheatsheet.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'christoomey/vim-tmux-navigator'
Plug 'sheerun/vim-polyglot'

call plug#end()

" -----------------------------------------------------------------------------
"NERDTree
" -----------------------------------------------------------------------------
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
nnoremap <expr> <leader>t g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'

" -----------------------------------------------------------------------------
"emmet
" -----------------------------------------------------------------------------
let g:user_emmet_leader_key=','

" -----------------------------------------------------------------------------
"Coc
" -----------------------------------------------------------------------------
let g:coc_global_extensions = [
			\ 'coc-tsserver'
			\]

:hi Comment ctermfg=gray
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> gd :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gr <Plug>(coc-references)

"coc colors
:hi CocErrorSign ctermbg=black
:hi CocWarningSign ctermbg=black
:hi CocInfoSign ctermbg=black
:hi CocHintLine ctermbg=black
:hi CocFloating ctermbg=black

" -----------------------------------------------------------------------------
"Telescope
" -----------------------------------------------------------------------------
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fb <cmd>Telescope builtin<cr>
lua << EOF
require('telescope').setup{ defaults = { file_ignore_patterns = { "node_modules" }} }
EOF

" -----------------------------------------------------------------------------
"Airline
" -----------------------------------------------------------------------------
let g:airline_theme = 'base16_dracula'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
set noshowmode

" -----------------------------------------------------------------------------
" Toggler
" -----------------------------------------------------------------------------
nnoremap <leader>b :ToggleAlternate<CR>

" -----------------------------------------------------------------------------
" ZenMode
" -----------------------------------------------------------------------------
nnoremap <leader>z :ZenMode<CR>
lua << EOF
  require("zen-mode").setup {
		kitty = {
			enabled = true,
			font = "+4", -- font size increment
		},
  }
EOF



" -----------------------------------------------------------------------------
" vimwiki
" -----------------------------------------------------------------------------
let g:wiki_root = '~/notes'
let g:wiki_filetypes = ['md']
let g:wiki_link_extension = '.md'

" -----------------------------------------------------------------------------
" gitsigns
" -----------------------------------------------------------------------------
lua << EOF
require('gitsigns').setup({
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 0,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
})
EOF
nnoremap <leader>gb :Gitsigns toggle_current_line_blame<cr>
highlight GitSignsCurrentLineBlame guibg=transparent guifg=bg


" -----------------------------------------------------------------------------
"SKELETON
" -----------------------------------------------------------------------------
nnoremap <leader>rt :-1read $HOME/.config/nvim/skeleton/react_tsx<cr>8gg0fEciw<C-r>=expand("%:t")<CR><Esc>2b2dw
nnoremap <leader>rj :-1read $HOME/.config/nvim/skeleton/react_jsx<cr>3gg0fEciw<C-r>=expand("%:t")<CR><Esc>2b2dw
nnoremap <leader>ignorevim :-1read $HOME/.config/nvim/skeleton/ignorevim<cr>
nnoremap <leader>tern :-1read $HOME/.config/nvim/skeleton/ternaryoperatorjsx<cr>0atrue<Esc>:Prettier<cr>wciw
nnoremap <leader>cl :-1read $HOME/.config/nvim/skeleton/className<cr>ci"
nnoremap <leader>api :-1read $HOME/.config/nvim/skeleton/node_api<cr>3gg0fAciw<C-r>=expand("%:t")<CR><Esc>GkfAciw<C-r>=expand("%:t")<CR><Esc>
nnoremap <leader>hook :-1read $HOME/.config/nvim/skeleton/react_hook<cr>3gg0fHciw<C-r>=expand("%:t")<CR><Esc>GkfHciw<C-r>=expand("%:t")<CR><Esc>11ggfAciw
nnoremap <leader>post :-1read $HOME/.config/nvim/skeleton/axois_post<cr>fFciw

" -----------------------------------------------------------------------------
"Testing
" -----------------------------------------------------------------------------
set nojoinspaces
set updatetime=300 " Reduce time for highlighting other references
set redrawtime=10000 " Allow more time for loading syntax on large files



"highlight IndentColor guifg=#1F5C53
"let g:indent_blankline_char_highlight_list = ['IndentColor']

lua << EOF
  require("todo-comments").setup {}
EOF
