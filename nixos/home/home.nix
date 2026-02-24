{ config, pkgs, ... }:
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  manual.manpages.enable = false;

  home.packages = with pkgs; [

    # NixOS
    cachix
    nix-index
    nix-prefetch-git
    nix-tree
    # appimage-run
    patchelf
    # home-manager

    # shell / dev utils
    asciinema
    # w3m
    yq
    hplipWithPlugin
    # Build systems
    # cmake gnumake ninja meson

    # Debuggers
    # gdb lldb_13

    # C/C++ toolchain
    # GCC9 should have the highest priority
    # (lib.setPrio 30 binutils) (lib.setPrio 20 clang_11) (lib.setPrio 10 gcc10) lld_11

    # Haskell
    # ghc

    # Python
    # python3

    # crypto & network
    # nethogs # monitoring

    bat
    # gitAndTools.delta
    # gitAndTools.diff-so-fancy
    # teamviewer
    vscode

    # D toolchain
    #dmd dub ldc

    # DevOps
    # azure-cli
    docker-compose
    # kubernetes-helm
    # kubectl
    # terraform
    # lens

    # gui sys
    gparted
    # wireshark-qt
    mesa-demos
    openboard

    # gui general
    google-chrome firefox # opera # browsers
    virtualbox
    libreoffice
    nodePackages.npm
    discord
    slack telegram-desktop teams-for-linux zoom-us # IM / Video
    vscode # GUI text editors / IDEs
    postman # API client
    # remmina # remote desktop
    deluge transmission_4-gtk # P2P/Torrent
    tilix # alacritty # Terminal emulators
    spotify vlc mpv # Audio & video players
    # reaper audacity # Audio editing
    # blender # 3D modeling
    # gimp inkscape # Image editing
    pick-colour-picker
    gcolor3
    xclip xorg.xhost # X11 related
    # xournal # Edit PDFs
    # qrencode

    # sys
    # gptfdisk parted # disk partitioning
    ext4magic testdisk # disk recovery
    # iotop # monitoring
    p7zip unrar # archival and compression (unzip is installed via sys/*.nix)
    usbutils pciutils

    # blockchain
    # go-ethereum

    # themes
    gnome-tweaks
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
    speedtest-cli
    #shades-of-gray-theme
    #sierra-gtk-theme
    #solarc-gtk-theme
    #sweet
    #theme-obsidian2
    #theme-vertex
    veracrypt
    yarn
    yaru-theme
    #zuki-themes
  ];


  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Aleione";
        email = "bergamaschi@gmail.com";
      };
      alias = {
        lgl = "log --color --graph --pretty=format:'%C(bold red)%h%Creset  %<(13,trunc)%C(bold yellow)%cr%Creset %<(80,trunc)%s%Creset on %C(bold yellow)%ad%Creset by %C(bold blue)%an%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";
        lg = "log --color --graph --pretty=format:'%C(bold red)%h%Creset %<(80,trunc)%s%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";
        lrl = "log --color --reverse --pretty=format:'%C(bold red)%h%Creset  %<(13,trunc)%C(bold yellow)%cr%Creset %<(80,trunc)%s%Creset on %C(bold yellow)%ad%Creset by %C(bold blue)%an%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";
        lr = "log --color --reverse --pretty=format:'%C(bold red)%h%Creset %<(80,trunc)%s%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";
      };
      core.editor = "code";
      color.ui = true;
      diff.colorMoved = "dimmed-zebra";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
