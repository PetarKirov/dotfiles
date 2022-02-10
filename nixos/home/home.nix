{ config, pkgs, username, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";
  manual.manpages.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "google-chrome"
    "slack"
    "spotify-unwrapped"
    "spotify"
    "teamviewer"
    "unrar"
    "zoom"
  ];

  home.packages = with pkgs; [
    # Nix-related:
    cachix
    nix-index
    nix-prefetch-git
    nix-tree
    # appimage-run
    patchelf
    # home-manager

    # shell / dev utils:
    asciinema
    # w3m
    yq

    # Build systems:
    # cmake gnumake ninja meson

    # Debuggers:
    # gdb lldb_13

    # C/C++ toolchain:
    # GCC9 should have the highest priority
    # (lib.setPrio 30 binutils) (lib.setPrio 20 clang_11) (lib.setPrio 10 gcc10) lld_11

    # Haskell
    # ghc

    # Python
    # python3

    # crypto & network
    # nethogs # monitoring

    bat
    gitAndTools.delta
    gitAndTools.diff-so-fancy
    teamviewer
    unstable.vscode

    # D toolchain
    #unstable.dmd unstable.dub unstable.ldc

    # DevOps
    # azure-cli
    # docker-compose
    # kubernetes-helm
    # kubectl
    # terraform
    unstable.lens

    # gui sys
    gparted
    wireshark-qt
    glxinfo

    # gui general
    google-chrome firefox # opera # browsers
    # libreoffice
    unstable.onlyoffice-bin
    unstable.discord-ptb slack tdesktop unstable.teams zoom-us # IM / Video
    unstable.vscode # GUI text editors / IDEs
    unstable.postman # API client
    # remmina # remote desktop
    deluge transmission-gtk # P2P/Torrent
    tilix # alacritty # Terminal emulators
    spotify vlc mpv # Audio & video players
    # reaper audacity # Audio editing
    blender # 3D modeling
    gimp inkscape # Image editing
    pick-colour-picker
    gcolor3
    xclip xorg.xhost # X11 related
    xournal # Edit PDFs
    # qrencode

    # sys
    # gptfdisk parted # disk partitioning
    ext4magic testdisk # disk recovery
    # iotop # monitoring
    p7zip unrar # archival and compression (unzip is installed via sys/*.nix)
    # usbutils pciutils

    # blockchain
    # go-ethereum

    # themes
    gnome3.gnome-tweaks
    paper-gtk-theme
    #paper-icon-theme
    #adementary-theme
    #adapta-gtk-theme
    #pantheon.elementary-gtk-theme
    #numix-gtk-theme
    #numix-sx-gtk-theme
    #onestepback
    #plano-theme
    #plata-theme
    qogir-theme
    #shades-of-gray-theme
    #sierra-gtk-theme
    #solarc-gtk-theme
    #sweet
    #theme-obsidian2
    #theme-vertex
    yaru-theme
    #zuki-themes
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    includes = [ { path = ../../.gitconfig; } ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
