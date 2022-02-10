{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, nixpkgs-unstable, ... }:
  let
    username = "zlx";
    host = "zlx-nixos-desktop";
  in
  {
    nixosConfigurations = let
      system = "x86_64-linux";
    in {
      "${host}" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/machines/${host}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./nixos/home/home.nix;
            home-manager.extraSpecialArgs = {
              inherit username;
              unstablePkgs = import nixpkgs-unstable {
                inherit system;
                config = { allowUnfree = true; };
              };
            };
          }
        ];
      };
    };
  };
}
