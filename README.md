# Nix Flakes-based System and Home Configuration and some Install Scripts

[![Actions Status](https://github.com/PetarKirov/dotfiles/workflows/CI/badge.svg)](https://github.com/PetarKirov/dotfiles/actions)
osx
`flake.nix` is the repo entrypoint. It contains the following outputs:

* `nixosConfigurations.*` - [NixOS][0] system configurations
* `homeConfigurations.*` - Nix [Home Manager][1] configuration
* `nixOnDroidConfigurations.*` - [Nix-on-Droid][2] configuration for Nix-powered Android shell environment

Additionally, this repo contains config (dot) files for:

* [Git](https://git-scm.com/)
* [Fish (Shell)](https://fishshell.com/)
* [NeoVim](https://neovim.io/)

[0]: https://nixos.org/
[1]: https://github.com/nix-community/home-manager
[2]: https://github.com/t184256/nix-on-droid
