{
  pkgs,
  unstablePkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    bat
    ripgrep
    gitAndTools.diff-so-fancy
    jq
    yq
    curl
    tree
    htop
    rage
    age-plugin-yubikey
  ];

  programs.exa = {
    enable = true;
    icons = true;
    git = true;
    extraOptions = ["--group-directories-first"];
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
