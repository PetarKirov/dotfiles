{ config, pkgs, ... }:
{
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    iputils
    openssl bind
    curl wget
    git
    neovim
    tree
    jq
  ];
}
