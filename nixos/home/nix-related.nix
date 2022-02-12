{ pkgs }:
with pkgs; [
  cachix
  nix-index
  nix-prefetch-git
  nix-tree
  # appimage-run
  patchelf
]
