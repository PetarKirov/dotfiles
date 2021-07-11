{ config, pkgs, ... }:
{
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  nix = {
   package = pkgs.nixFlakes;
   extraOptions = ''
     experimental-features = nix-command flakes
   '';
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DroidSansMono" "FiraCode" "FiraMono"]; })
  ];

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    exfat ntfs3g
    unzip
    curl wget
    openssl bind gnupg nmap
    wireguard
    iputils
    htop
    file
    ripgrep
    git
    neovim
    tree
    jq
    direnv
  ];
}
