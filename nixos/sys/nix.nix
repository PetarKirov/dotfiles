{
  pkgs,
  unstablePkgs,
  defaultUser,
  ...
}: {
  nix = {
    package = unstablePkgs.nixVersions.nix_2_14;
    settings = {
      trusted-users = ["root" defaultUser];
      experimental-features = ["nix-command" "flakes"];
    };
  };
}
