{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = "https://petar-kirov-dotfiles.cachix.org";
    extra-trusted-public-keys = "petar-kirov-dotfiles.cachix.org-1:WW4VsSGibdlNBDpqSsVhjVpz5/FZBX8uS0+yLdFEYP0=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    nix-on-droid,
    flake-parts,
    ...
  } @ inputs: let
    defaultUser = "zlx";
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      _module.args = {inherit defaultUser;};
      imports = [./nixos/machines];
      flake = {
        nixOnDroidConfigurations.device = nix-on-droid.lib.nixOnDroidConfiguration {
          config = ./nix-on-droid.nix;
          system = "aarch64-linux";
        };
      };
      perSystem = {
        pkgs,
        unstablePkgs,
        system,
        inputs',
        ...
      }: let
        makeHomeConfig = modules: username:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs modules;
            extraSpecialArgs = {inherit username unstablePkgs inputs';};
          };
      in {
        _module.args = {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          unstablePkgs = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        devShells.default = import ./shell.nix {inherit pkgs;};
        legacyPackages.homeConfigurations = rec {
          ${defaultUser} = home-config-full;
          home-config-base = makeHomeConfig [./nixos/home/base] defaultUser;
          home-config-full = makeHomeConfig [./nixos/home/full] defaultUser;
          home-config-macos = makeHomeConfig [./nixos/home/macos] "pkirov";
        };
      };
    };
}
