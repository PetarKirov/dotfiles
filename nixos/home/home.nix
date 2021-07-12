{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  commaSrc = pkgs.fetchFromGitHub {
    owner  = "Shopify";
    repo   = "comma";
    rev    = "4a62ec17e20ce0e738a8e5126b4298a73903b468";
    sha256 = "sha256-IT7zlcM1Oh4sWeCJ1m4NkteuajPxTnNo1tbitG0eqlg=";
  };
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "zlx";
  home.homeDirectory = "/home/zlx";
  manual.manpages.enable = false;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    (callPackage commaSrc {})

    # NixOS
    cachix
    nix-tree
    # appimage-run
    # patchelf
    # home-manager

    # shell / dev utils
    asciinema
    # w3m
    yq

    # Build systems
    # cmake gnumake ninja meson

    # Debuggers
    # gdb lldb_11

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
    # unstable.lens

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
    unstable.insomnia # API client
    # remmina # remote desktop
    deluge transmission-gtk # P2P/Torrent
    tilix # alacritty # Terminal emulators
    spotify vlc # Audio & video players
    #audacity # Audio editing
    #blender # 3D modeling
    gimp inkscape # Image editing
    pick-colour-picker
    svgcleaner # SVG optimization
    xclip xorg.xhost # X11 related
    # qrencode

    # sys
    # gptfdisk parted # disk partitioning
    # ext4magic testdisk # disk recovery
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
    userName = "Petar Kirov";
    userEmail = "petar.p.kirov@gmail.com";
    #delta.enable = true;
    aliases = {
	# lg - show git log
	# lr - show git log in reverse
	# lgl - show git log in long (more verbose) mode
	# lrl - show git log reverse in long (more verbose) mode
    	lgl = "log --color --graph --pretty=format:'%C(bold red)%h%Creset  %<(13,trunc)%C(bold yellow)%cr%Creset %<(80,trunc)%s%Creset 💾 on %C(bold yellow)%ad%Creset by %C(bold blue)%an%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";

	lg = "log --color --graph --pretty=format:'%C(bold red)%h%Creset %<(80,trunc)%s%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";

	lrl = "log --color --reverse --pretty=format:'%C(bold red)%h%Creset  %<(13,trunc)%C(bold yellow)%cr%Creset %<(80,trunc)%s%Creset 💾 on %C(bold yellow)%ad%Creset by %C(bold blue)%an%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";

	lr = "log --color --reverse --pretty=format:'%C(bold red)%h%Creset %<(80,trunc)%s%Creset %C(yellow)%d' --abbrev-commit '--date=format:%d %b %Y'";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      color = {
        ui = true;
      };
      diff = {
      	colorMoved = "dimmed-zebra";
      };
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
  home.stateVersion = "20.09";
}
