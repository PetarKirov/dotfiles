{ config, pkgs, unstablePkgs, ... }:
{
  # Let Home Manager install and manage itself.
  manual.manpages.enable = false;
  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    bash.enable = true;
    fish.enable = true;
  };

  home.sessionVariables = {
    DIRENV_WARN_TIMEOUT = "30s";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
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
    ./git.nix
    ./xdg-symlinks.nix
    ./dconf.nix

    ./pkg-sets/system-utils.nix
    ./pkg-sets/cli-utils.nix
    ./pkg-sets/dev-toolchain.nix
    ./pkg-sets/gui.nix
    ./pkg-sets/nix-related.nix
    ./pkg-sets/gnome-themes.nix
  ];
}
