{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { home-manager, nixpkgs, nixpkgs-unstable, nix-on-droid, ... }:
  let
    username = "zlx";
    hostname = "zlx-nixos-desktop";
    system = "x86_64-linux";
  in
  {
    nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./nixos/machines/import-machine.nix ];
      specialArgs = { inherit username hostname; };
    };

    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit system username;
      homeDirectory = "/home/${username}";
      configuration = import ./nixos/home/home.nix;
      extraSpecialArgs = {
        unstablePkgs = import nixpkgs-unstable {
          inherit system;
          config = { allowUnfree = true; };
        };
      };
      # Update the state version as needed.
      # See the changelog here:
      # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
      stateVersion = "21.11";
    };

    nixOnDroidConfigurations = {
      device = nix-on-droid.lib.nixOnDroidConfiguration {
        config = ./nix-on-droid.nix;
        system = "aarch64-linux";
        extraModules = [
          # import source out-of-tree modules like:
          # flake.nixOnDroidModules.module
        ];
        extraSpecialArgs = {
          # arguments to be available in every nix-on-droid module
        };
        # your own pkgs instance (see nix-on-droid.overlay for useful additions)
        # pkgs = ...;
      };
    };
  };
}
