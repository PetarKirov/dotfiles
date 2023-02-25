{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    gitAndTools.diff-so-fancy
    jq
    yq
  ];
}
