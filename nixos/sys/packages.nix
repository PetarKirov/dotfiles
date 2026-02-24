{ config, pkgs, ... }:
{
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  nixpkgs.config.allowUnfree = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
  ];

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    exfat ntfs3g
    unzip
    curl wget
    openssl bind gnupg nmap
    wireguard-tools
    iputils
    htop
    file
    ripgrep
    git
    tree
    jq
    direnv
  ];
}
