{ config, pkgs, unstablePkgs, ... }:
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  manual.manpages.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord-ptb"
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
    ./pkg-sets/system-utils.nix
    ./pkg-sets/cli-utils.nix
    ./pkg-sets/dev-toolchain.nix
    ./pkg-sets/gui.nix
    ./pkg-sets/nix-related.nix
    ./pkg-sets/gnome-themes.nix
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    delta.enable = true;
    includes = [
      { path = ../../.gitconfig; }
      { path = ../../.config/git/aliases.gitconfig; }
      { path = ../../.config/git/delta.gitconfig; }
      { path = ../../.config/git/delta-themes.gitconfig; }
    ];
  };
}
