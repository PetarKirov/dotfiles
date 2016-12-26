set nocompatible              " be iMproved, required
filetype off                  " required

" Show numbers on the left of the screen
set relativenumber

" Begins searching as you type
set incsearch

" Enable syntax mode for code folding
set foldmethod=syntax

" Does not include the cursor in the selection
" set selection=exclusive

" Enable the mouse
set mouse=a

" Change cursor shape in different modes
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[5 q"

" Underline matching braces
" http://design.liberta.co.za/articles/customizing-disabling-vim-matching-parenthesis-highlighting/
:hi MatchParen cterm=underline ctermbg=none ctermfg=none

:hi Folded ctermbg=none

highlight ColorColumn ctermbg=none cterm=undercurl ctermfg=darkgrey

let g:airline_powerline_fonts = 1

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" For cool status bar:
Plugin 'bling/vim-airline'

" For git diff stats
Plugin 'airblade/vim-gitgutter'

" Git wrapper for vim
Plugin 'tpope/vim-fugitive'

" http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
Plugin 'godlygeek/tabular'

" Markdown for VIM. Should also provide folding
" http://vimcasts.org/episodes/how-to-fold/
Plugin 'plasticboy/vim-markdown'

" EditorConfig
Plugin 'editorconfig/editorconfig-vim'

" Color schemes:
Plugin 'chriskempson/base16-vim'

" Easily delete, change and add surroundings in pairs
Plugin 'tpope/vim-surround'

Plugin 'terryma/vim-multiple-cursors'

" Track the engine.
Plugin 'SirVer/ultisnips'
"
" " Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
"
" " Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" For file explorer tree:
Plugin 'scrooloose/nerdtree'

Plugin 'ntpeters/vim-better-whitespace'

" For GDB integration
Plugin 'vim-scripts/Conque-GDB'

" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" " To ignore plugin indent changes, instead use:
" "filetype plugin on
" "
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line

set laststatus=2
set background=dark
" colorscheme base16-eighties
