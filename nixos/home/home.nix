{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  # Let Home Manager install and manage itself.
  manual.manpages.enable = false;
  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    bash.enable = true;
  };

  home.sessionVariables = rec {
    DIRENV_WARN_TIMEOUT = "30s";
    CODE = "${config.home.homeDirectory}/code";
    TMPCODE = "${CODE}/tmp";
    REPOS = "${CODE}/repos";
    CFG = "${REPOS}/dotfiles";
    DLANG = "${REPOS}/dlang";
    WORK = "${REPOS}/metacraft-labs";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "discord"
      "google-chrome"
      "postman"
      "slack"
      "spotify-unwrapped"
      "spotify"
      "teams"
      "teamviewer"
      "unrar"
      "zoom"
    ];

  imports = [
    ./dconf.nix
    ./shells/fish.nix
    ./git.nix
    ./xdg-symlinks.nix

    ./pkg-sets/cli-utils.nix
    ./pkg-sets/dev-toolchain.nix
    ./pkg-sets/gnome-themes.nix
    ./pkg-sets/gui.nix
    ./pkg-sets/nix-related.nix
    ./pkg-sets/system-utils.nix
  ];
}
