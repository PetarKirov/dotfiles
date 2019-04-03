"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state("/home/".$USER."/.cache/dein")
  call dein#begin("/home/".$USER."/.cache/dein")

  " Let dein manage dein
  " Required:
  call dein#add('/home/'.$USER.'/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Plugins begin:

  " EditorConfig support: https://editorconfig.org/
  call dein#add('editorconfig/editorconfig-vim')

  " File explorer
  call dein#add('scrooloose/nerdtree')
  call dein#add('Xuyuanp/nerdtree-git-plugin')

  " File type glyphs/icons
  call dein#add('ryanoasis/vim-devicons')
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:DevIconsEnableFoldersOpenClose = 1

  " Multiple cursors
  call dein#add('mg979/vim-visual-multi')

  " Cool status bar
  call dein#add('vim-airline/vim-airline')

  " Language support
  call dein#add('JesseKPhillips/d.vim')
  call dein#add('dag/vim-fish')
  call dein#add('tomlion/vim-solidity')

  " Themes
  call dein#add('joshdick/onedark.vim')
  call dein#add('mhartington/oceanic-next')

  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" Install plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

" ----- Color handling start -----

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" ----- Color handling end -----

" Hybrid number mode
set relativenumber
set number

set encoding=UTF-8

" Allow to go back to Normal mode from Insert mode
" without quiting from the multiple cursor mode.
let g:multi_cursor_exit_from_insert_mode=0

syntax on
filetype plugin indent on
colorscheme OceanicNext
set mouse=a
set background=dark
set incsearch
set foldmethod=syntax
