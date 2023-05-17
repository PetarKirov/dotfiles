{
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    bat
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
}
