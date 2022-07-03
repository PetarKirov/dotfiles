{
  config,
  pkgs,
  defaultUser,
  ...
}: {
  services.openssh.enable = true;
  services.tailscale.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["DroidSansMono" "FiraCode" "FiraMono"];})
  ];

  programs.git = {
    enable = true;
    config = {
      safe.directory = "/home/${defaultUser}/code/repos/dotfiles";
    };
  };

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
    exfat
    ntfs3g
    unzip
    curl
    wget
    openssl
    bind
    gnupg
    nmap
    wireguard-tools
    iputils
    pciutils
    htop
    file
    ripgrep
    tree
    jq
    direnv
  ];
}
