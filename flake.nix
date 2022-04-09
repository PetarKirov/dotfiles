{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = "https://petar-kirov-dotfiles.cachix.org";
    extra-trusted-public-keys = "petar-kirov-dotfiles.cachix.org-1:WW4VsSGibdlNBDpqSsVhjVpz5/FZBX8uS0+yLdFEYP0=";
  };

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

  outputs = {
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    nix-on-droid,
    ...
  }: let
    system = "x86_64-linux";
    defaultUser = "zlx";
    users = [defaultUser];

    machines = builtins.attrNames (
      nixpkgs.lib.filterAttrs
      (n: v: v == "directory")
      (builtins.readDir ./nixos/machines)
    );

    makeMachineConfig = defaultUser: hostname: {
      name = hostname;
      value = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./nixos/machines/import-machine.nix];
        specialArgs = {inherit defaultUser hostname;};
      };
    };

    makeHomeConfig = username: {
      name = username;
      value = home-manager.lib.homeManagerConfiguration {
        inherit system username;
        homeDirectory = "/home/${username}";
        configuration = import ./nixos/home/home.nix;
        extraSpecialArgs = {
          unstablePkgs = import nixpkgs-unstable {
            inherit system;
            config = {allowUnfree = true;};
          };
        };
        stateVersion = "21.11";
      };
    };

    makeNixOnDroidConfig = username:
      nix-on-droid.lib.nixOnDroidConfiguration {
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
  in {
    nixosConfigurations = builtins.listToAttrs (builtins.map (makeMachineConfig defaultUser) machines);
    homeConfigurations = builtins.listToAttrs (builtins.map makeHomeConfig users);
    nixOnDroidConfigurations = {device = makeNixOnDroidConfig defaultUser;};
  };
}
