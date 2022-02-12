{ pkgs, unstablePkgs }:
with pkgs; [
  ## Browsers:
  google-chrome firefox # opera

  ## Audio & video players:
  spotify vlc mpv

  ## Office:
  # libreoffice
  onlyoffice-bin
  xournal

  ## IM / Video:
  discord-ptb
  slack
  tdesktop
  teams
  zoom-us

  ## Text editors / IDEs
  unstablePkgs.vscode

  ## API clients:
  # insomnia
  postman

  ## Remote desktop:
  # remmina
  # teamviewer

  ## P2P:
  deluge transmission-gtk

  ## Terminal emulators:
  # alacritty
  tilix

  ## Audio editing:
  # reaper audacity

  ## 3D modeling:
  blender

  ## Image editing:
  gimp inkscape
  pick-colour-picker
  gcolor3

  ## X11, OpenGL, Vulkan:
  xclip
  xorg.xhost
  glxinfo
  vulkan-tools

  ## System:
  gparted
  wireshark-qt
]
