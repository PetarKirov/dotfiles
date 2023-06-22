{
  pkgs,
  unstablePkgs,
  inputs',
  ...
}: {
  home.packages = with pkgs;
    [
      cachix
      unstablePkgs.nurl
      unstablePkgs.nix-init
      nix-tree
      patchelf
      alejandra
      nix-output-monitor
    ]
    ++ [
      inputs'.nixd.packages.default
    ];
}
