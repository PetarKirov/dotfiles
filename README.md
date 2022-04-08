# Nix Flakes-based System & Home Configuration, Dotfiles, and Install Scripts

## CI Status

| CI Workflow                     | Target Platform                | CI Job Status                                                                                                                                                                      |
| ------------------------------- | ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| NixOS System Configuration      | NixOS                          | [![NixOS][gh-actions-nixos]][gh-actions]                                                                                                                                           |
| Home Manager User Configuration | Linux / macOS                  | [![Nix Home Manager][gh-actions-nix-hm]][gh-actions]                                                                                                                               |
| Nix-on-Droid                    | Android                        | (not implemented yet)                                                                                                                                                              |
| Legacy Install Scripts          | Linux + distro package manager | [![Alpine][gh-actions-alpine]][gh-actions] [![Arch Linux][gh-actions-archlinux]][gh-actions] [![Debian][gh-actions-debian]][gh-actions] [![Ubuntu][gh-actions-ubuntu]][gh-actions] |
| Legacy Install Scripts          | macOS + HomeBrew               | [![macOS][gh-actions-macos]][gh-actions]                                                                                                                                           |

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
[gh-actions-macos]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.macOS-latest
[gh-actions-nixos]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.nixos
[gh-actions-nix-hm]: https://github-actions.40ants.com/PetarKirov/dotfiles/matrix.svg?only=ci.nix-hm

### Installation

1. Boot into a live NixOS environment (either a live USB containing the NixOS
installer or an existing NixOS installed on another drive)
2. Clone this repo and `cd` into it:
`git clone https://github.com/PetarKirov/dotfiles && cd dotfiles`
3. Run the automated ZFS partitioning tool:
   * Run it in "dry-run" mode to get information about your system:
     `./utils/make_zfs.bash`
   * If you need to partition your drive run:
     `env DRY_RUN=0 KEEP_PARTITIONS=0 ./utils/make_zfs.bash`
   * If your drive is already partitioned, run: `env DRY_RUN=0
     ./utils/make_zfs.bash`
4. Now there should be a root ZFS partition mounted at `/mnt`. To install NixOS
there, run:

   ```sh
   nixos-generate-config --root /mnt --dir /../home/zlx/code/repos/dotfiles/nixos/machines/zlx-nixos-desktop3

   sudo nixos-install --impure --flake '.#zlx-nixos-desktop2' --root /mnt
   ```

   (Replace `zlx-nixos-desktop2` in the command above with the name of the
   machine config you want to apply.)

5. Now that NixOS is installed, chroot into (using `nixos-enter`) and change the
password of the default user:

   ```sh
   sudo nixos-enter --root /mnt
   passwd zlx
   exit
   ```

   (Replace `zlx` in the command above with the your username.)

6. Copy the `dotfiles` repo inside the user's home dir:

   ```sh
   mkdir -p /mnt/home/zlx/code/repos
   cp -a ../dotfiles /mnt/home/zlx/code/repos
   ```

7. Build the home-manager config and copy it to the new Nix Store:

   ```sh
   nix build '.#homeConfigurations.zlx.activationPackage'
   sudo nix copy --to /mnt ./result/ --no-check-sigs
   ```

8. Reboot into the new Nix install, open a terminal, cd into the dotfiles dir and activate the home-manager config:

   ```sh
   cd /home/zlx/code/repos/dotfiles
   nix path-info '.#homeConfigurations.zlx.activationPackage' | xargs -I@@ sh -c '@@/activate'
   ```

9. You're done!
