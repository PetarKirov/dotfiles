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

  environment.systemPackages = with pkgs; [
    unzip
    iputils
    openssl bind
    curl wget
    git
    neovim
    tree
    jq
    direnv
  ];
}
