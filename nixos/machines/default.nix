{lib}: let
  allHosts = builtins.attrNames (
    lib.filterAttrs
    (n: v: v == "directory")
    (builtins.readDir ./.)
  );

  makeNixOSConfig = defaultUser: hostname:
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
in
  defaultUser:
    lib.genAttrs allHosts (makeNixOSConfig defaultUser)
