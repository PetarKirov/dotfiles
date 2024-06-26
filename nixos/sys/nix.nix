{
  pkgs,
  defaultUser,
  ...
}: {
  nix = {
    distributedBuilds = true;
    settings = {
      trusted-users = ["root" defaultUser];
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      builders-use-substitutes = true;
      builders = "@/etc/nix/machines";
    };
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };
}
