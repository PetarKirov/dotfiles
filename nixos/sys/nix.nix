{
  pkgs,
  defaultUser,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      trusted-users = ["root" defaultUser];
      experimental-features = ["nix-command" "flakes"];
    };
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };
}
