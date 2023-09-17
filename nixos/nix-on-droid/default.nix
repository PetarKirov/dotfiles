{
  withSystem,
  inputs,
  ...
}: {
  flake.nixOnDroidConfigurations = {
    default = withSystem "aarch64-linux" (
      {inputs', ...}: let
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
          overlays = [inputs.nix-on-droid.overlays.default];
        };

        unstablePkgs = import inputs.nixpkgs-unstable {
          system = "aarch64-linux";
          overlays = [inputs.nix-on-droid.overlays.default];
        };
      in
        inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          inherit pkgs;

          modules = [
            ({config, ...}: {
              system.stateVersion = "23.05";
              environment.etcBackupExtension = ".bak";
              time.timeZone = "Europe/Sofia";
              nix.extraOptions = ''
                experimental-features = nix-command flakes
              '';
              user.shell = "${pkgs.fish}/bin/fish";
              home-manager = {
                config = ../home/base;
                backupFileExtension = "hm-bak";
                useGlobalPkgs = true;
                extraSpecialArgs = {
                  inherit unstablePkgs inputs inputs';
                };
              };
            })

            # { nix.registry.nixpkgs.flake = nixpkgs; }
          ];

          extraSpecialArgs = {
            inherit unstablePkgs inputs inputs';
          };

          home-manager-path = inputs.home-manager.outPath;
        }
    );
  };
}
