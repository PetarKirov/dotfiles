{
  pkgs,
  unstablePkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # foundational tools
    which
    findutils
    gnugrep
    utillinux
    diffutils
    curl
    htop
    ncurses
    tzdata
    hostname
    man
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip

    # crypto-related
    gnupg
    openssh
    openssl

    # icing
    bat
    ripgrep
    gitAndTools.diff-so-fancy
    jq
    yq
    tree
    rage
    gh
    age-plugin-yubikey
    lunarvim
  ];

  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--hyperlink"
      "--color-scale"
      "--binary"
    ];
  };

  programs.zellij = {
    enable = true;
    package = unstablePkgs.zellij;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraLuaConfig = ''
      vim.cmd [[source ${config.home.sessionVariables.CFG}/.config/nvim/general-settings.vim]]
      vim.cmd [[source ${config.home.sessionVariables.CFG}/.config/nvim/dein-plugins.vim]]
      vim.cmd [[source ${config.home.sessionVariables.CFG}/.config/nvim/plugin-cfg.vim]]
    '';
  };

  programs.mr = {
    enable = true;
    settings = {
      ".local/share/dein/repos/github.com/Shougo/dein.vim" = {
        checkout = "git clone https://github.com/Shougo/dein.vim";
      };
    };
  };
}
