{
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    cachix
    unstablePkgs.nurl
    nix-tree
    patchelf
    alejandra
  ];
}
