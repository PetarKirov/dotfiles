{
  lib,
  pkgs,
  unstablePkgs,
  inputs,
  inputs',
  ...
}:
with pkgs; {
  home.packages =
    [
      cachix
      unstablePkgs.nurl
      unstablePkgs.nix-init
      nix-tree
      nix-diff
      patchelf
      alejandra
      nix-output-monitor
    ]
    ++ lib.optionals (stdenv.isLinux) [
      inputs'.nixd.packages.default
    ]
    ++ lib.optionals (stdenv.isDarwin) [
      inputs.nixd.packages.x86_64-darwin.default
    ];
}
