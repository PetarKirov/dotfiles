{
  pkgs,
  defaultUser,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.nix_2_16;
    settings = {
      trusted-users = ["root" defaultUser];
      experimental-features = ["nix-command" "flakes"];
    };
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };
}
