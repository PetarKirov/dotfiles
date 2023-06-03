{
  lib,
  inputs,
  defaultUser,
  ...
}: let
  allHosts = builtins.attrNames (
    lib.filterAttrs
    (n: v: v == "directory")
    (builtins.readDir ./.)
  );

  makeNixOSConfig = hostname:
    lib.nixosSystem {
      modules = [
        inputs.flake-utils-plus.nixosModules.autoGenFromInputs
        {
          networking.hostName = hostname;
          nixpkgs.config.allowUnfree = true;
          imports = [
            ../sys
            ./${hostname}/configuration.nix
            ./${hostname}/hardware-configuration.nix
          ];
        }
      ];
      specialArgs = {inherit defaultUser inputs;};
    };
in {
  flake = {
    nixosConfigurations = lib.genAttrs allHosts makeNixOSConfig;
  };
}
