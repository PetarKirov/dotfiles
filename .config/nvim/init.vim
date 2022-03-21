if &compatible
  set nocompatible               " Be iMproved
endif

let cfg_dir = exists('$XDG_CONFIG_HOME') ? $XDG_CONFIG_HOME : $HOME . '/.config'
let cfg_dir = cfg_dir . '/nvim'

exec 'source' cfg_dir . '/dein-plugins.vim'
exec 'source' cfg_dir . '/general-settings.vim'
exec 'source' cfg_dir . '/plugin-cfg.vim'
