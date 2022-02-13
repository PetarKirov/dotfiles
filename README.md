# Nix Flakes-based System & Home Configuration, Dotfiles, and Install Scripts

## CI Status

| CI Workflow     | Platform           |                                 |                                        |                                 |                                 |                                     |
|-----------------|--------------------|---------------------------------|----------------------------------------|---------------------------------|---------------------------------|-------------------------------------|
| Install Scripts | Linux (via Docker) | [![Alpine][gh-actions-alpine]][gh-actions] | [![Arch Linux][gh-actions-archlinux]][gh-actions] | [![Debian][gh-actions-debian]][gh-actions] | [![Ubuntu][gh-actions-ubuntu]][gh-actions] | [![Homebrew][gh-actions-homebrew]][gh-actions] |
| Install Scripts | macOS              | [![macOS][gh-actions-macos]][gh-actions]   |                                        |                                 |                                 |                                     |
| NixOS           | NixOS              | (not implemented yet)           |                                        |                                 |                                 |                                     |
| Home Manager    | NixOS              | (not implemented yet)           |                                        |                                 |                                 |                                     |
| Nix-on-Droid    | NixOS              | (not implemented yet)           |                                        |                                 |                                 |                                     |

---

Overall status: [![Actions Status](https://github.com/PetarKirov/dotfiles/workflows/CI/badge.svg)](https://github.com/PetarKirov/dotfiles/actions)

## Description

This repo contains my personal system configuration based comprised of:

* Install scripts (tested on: [{see CI matrix above}](#ci-status))
* Dotfiles
  * [Git](https://git-scm.com/)
  * [Fish (Shell)](https://fishshell.com/)
  * [NeoVim](https://neovim.io/)
  * [EditorConfig](https://editorconfig.org/)
  * [Prettier](https://prettier.io/)
* NixOS system config
  * [`boot.nix`](./nixos/sys/boot.nix)
  * [`extra_services.nix`](./nixos/sys/extra_services.nix)
  * [`gnome_desktop_env.nix`](./nixos/sys/gnome_desktop_env.nix)
  * [`i18n.nix`](./nixos/sys/i18n.nix)
  * [`ledger-nano-udev-rules.nix`](./nixos/sys/ledger-nano-udev-rules.nix)
  * [`networking.nix`](./nixos/sys/networking.nix)
  * [`packages.nix`](./nixos/sys/packages.nix)
  * [`users.nix`](./nixos/sys/users.nix)
* Nix Home Manager config
  * [`home.nix`](./nixos/home/home.nix)
  * [`git.nix`](./nixos/home/git.nix)
  * [`pkgs-sets/`](./nixos/home/pkg-sets/pkgs-sets/)
    * [`cli-utils.nix`](./nixos/home/pkg-sets/cli-utils.nix)
    * [`dev-toolchain.nix`](./nixos/home/pkg-sets/dev-toolchain.nix)
    * [`gnome-themes.nix`](./nixos/home/pkg-sets/gnome-themes.nix)
    * [`gui.nix`](./nixos/home/pkg-sets/gui.nix)
    * [`nix-related.nix`](./nixos/home/pkg-sets/nix-related.nix)
    * [`system-utils.nix`](./nixos/home/pkg-sets/system-utils.nix)
* Nix-on-Droid config (WIP)

### Nix Flakes

[Nix Flakes][nix-flakes] are used to organize and package the Nix code.

`flake.nix` is the repo entrypoint. It contains the following outputs:

* `nixosConfigurations.*` - [NixOS][nixos] system configurations
* `homeConfigurations.*` - Nix [Home Manager][home-mgr] configuration
* `nixOnDroidConfigurations.*` - [Nix-on-Droid][nix-on-droid] configuration for Nix-powered Android shell environment

[nixos]: https://nixos.org/
[home-mgr]: https://github.com/nix-community/home-manager
[nix-on-droid]: https://github.com/t184256/nix-on-droid
[nix-flakes]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html

[gh-actions]: https://github.com/PetarKirov/dotfiles/actions

[gh-actions-alpine]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.alpine
[gh-actions-archlinux]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.archlinux
[gh-actions-debian]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.debian
[gh-actions-ubuntu]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.ubuntu
[gh-actions-homebrew]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.homebrew
[gh-actions-macos]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.macOS-latest
