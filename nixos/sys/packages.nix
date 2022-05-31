{ config, pkgs, ... }:
{
  services.openssh.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DroidSansMono" "FiraCode" "FiraMono"]; })
  ];

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    configure.customRC = ''
      source ~/.config/nvim/init.vim
    '';
  };

  environment.systemPackages = with pkgs; [
    exfat ntfs3g
    unzip
    curl wget
    openssl bind gnupg nmap
    wireguard-tools
    iputils
    pciutils
    htop
    file
    ripgrep
    git
    tree
    jq
    direnv
  ];
}
