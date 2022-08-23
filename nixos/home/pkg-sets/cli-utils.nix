{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    gitAndTools.diff-so-fancy
    asciinema
    nushell
    gh
    # qrencode
    # w3m
    yq
  ];
}
