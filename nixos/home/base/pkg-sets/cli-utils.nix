{
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    bat
    ripgrep
    gitAndTools.diff-so-fancy
    jq
    yq
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
