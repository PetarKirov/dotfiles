" Set Dein base path (required)
let s:dein_base = '~/.local/share/dein'

" Set Dein source path (required)
let s:dein_src = '~/.local/share/dein/repos/github.com/Shougo/dein.vim'

" Set Dein runtime path (required)
execute 'set runtimepath+=' . s:dein_src

" Call Dein initialization (required)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

" Plugins begin:

" EditorConfig support: https://editorconfig.org/
call dein#add('editorconfig/editorconfig-vim')

" File explorer
call dein#add('scrooloose/nerdtree')

" Git related
call dein#add('Xuyuanp/nerdtree-git-plugin')
call dein#add('tpope/vim-fugitive')

" File type glyphs/icons
call dein#add('ryanoasis/vim-devicons')

" Center buffer
call dein#add('junegunn/goyo.vim')

" Multiple cursors
call dein#add('mg979/vim-visual-multi')

" Graphical undo
call dein#add('sjl/gundo.vim')

" Surround
call dein#add('tpope/vim-surround')

" Sort motion
call dein#add('christoomey/vim-sort-motion')

" Tabular
call dein#add('godlygeek/tabular')

" Cool status bar
call dein#add('vim-airline/vim-airline')

" Language support
call dein#add('JesseKPhillips/d.vim')
call dein#add('dag/vim-fish')
call dein#add('tomlion/vim-solidity')
call dein#add('pangloss/vim-javascript')
call dein#add('leafgarland/typescript-vim')
call dein#add('dart-lang/dart-vim-plugin')
call dein#add('thosakwe/vim-flutter')
call dein#add('LnL7/vim-nix')

" Themes
call dein#add('joshdick/onedark.vim')
call dein#add('mhartington/oceanic-next')
call dein#add('ghifarit53/tokyonight-vim')
call dein#add('1612492/github.vim')
call dein#add('rktjmp/lush.nvim')
call dein#add('rakr/vim-one')
call dein#add('sonph/onehalf')
call dein#add('dracula/vim')
call dein#add('jacoborus/tender.vim')
call dein#add('tomasiser/vim-code-dark')

"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')

" Install plugins on startup.
if dein#check_install()
  call dein#install()
endif
