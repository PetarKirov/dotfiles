{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    gitAndTools.diff-so-fancy
    asciinema
    nushell
    # qrencode
    # w3m
    yq
  ];
}
