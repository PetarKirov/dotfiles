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
      specialArgs = {inherit defaultUser;};
    };
in {
  flake = {
    nixosConfigurations = lib.genAttrs allHosts makeNixOSConfig;
  };
}
