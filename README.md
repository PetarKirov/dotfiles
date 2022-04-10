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

## Overview

This repo contains my personal system configuration that consists of:

* [My config](./nixos/sys/) for [NixOS](https://nixos.wiki/wiki/NixOS)
* [My config](./nixos/home/) for [Home Manager](https://github.com/nix-community/home-manager)
* [My](./utils/make_zfs.bash) ZFS partitioning and formatting script
* [My dotfiles](./.config) for [Git](https://git-scm.com/), [Fish](https://fishshell.com/), [NeoVim](https://neovim.io/), [EditorConfig](https://editorconfig.org/), [Prettier](https://prettier.io/)
* My config for [Nix-on-Droid](https://github.com/t184256/nix-on-droid) (WIP)
* [Old install scripts](./install/) (tested on: [{see CI matrix above}](#ci-status))

It [includes](./flake.nix) a [Nix Flake][nix-flakes] file which acts as an entrypoint for Nix and defines the following outputs:

* `nixosConfigurations.*` - [NixOS][nixos] system configurations
* `homeConfigurations.*` - Nix [Home Manager][home-mgr] configuration
* `nixOnDroidConfigurations.*` - [Nix-on-Droid][nix-on-droid] configuration for Nix-powered Android shell environment

## Basic Usage

This is how I apply my Nix configuration on my machines.
If you fork this repo (to modify it as per your needs), you should be able to use the same commands as they're written in a generic way.

### Apply NixOS system configuration

<dl>
  <dt>Bash $</dt>
  <dd>

  ```bash
  sudo nixos-rebuild switch --flake "$HOME/code/repos/dotfiles#$(hostname)"
  ```

  </dd>

  <dt>Fish ⋊&gt;</dt>
  <dd>

  ```fish
  sudo nixos-rebuild switch --flake $HOME/code/repos/dotfiles#(hostname)
  ```

  </dd>
</dl>

### Apply Home Manager user config

```bash
home-manager switch --flake "$HOME/code/repos/dotfiles#$USER"
```

### Manually update all Nix Flake inputs

```bash
nix flake update "$HOME/code/repos/dotfiles"
```

The versions of most software installed on the system are determined by the
Nixpkgs commit hash stored in the `flake.lock` file. Running the command above
will update it (and the other flake inputs) to latest version.

## Getting started

Clone the repo, e.g. to `$HOME/code/repos`:

```bash
git clone https://github.com/PetarKirov/dotfiles
```

Copy a machine configuration and modify it as needed:

```bash
cd dotfiles
cp -r nixos/machines/zlx-nixos-desktop2 nixos/machines/my-machine
# Edit nixos/machines/my-machine/*
```

## Nix Ecosystem Docs

* Find Nix packages: <https://search.nixos.org/packages>
* Browse NixOS configuration options:
  * Full list (on a single page): <https://nixos.org/manual/nixos/stable/options.html>
  * Search: <https://search.nixos.org/options>
* Home Manager docs: <https://nix-community.github.io/home-manager/>
  * Home Manager options: <https://nix-community.github.io/home-manager/options.html>
* Nix Language
  * Overview: <https://nixery.dev/nix-1p.html>
  * Nix cheatsheet: <https://learnxinyminutes.com/docs/nix>
  * Interactive tour of Nix: <https://nixcloud.io/tour/?id=1>
  * Official docs: <https://nixos.org/manual/nix/stable/expressions/writing-nix-expressions.html>
* Nix Flakes
  * An introduction: <https://christine.website/blog/nix-flakes-1-2022-02-21>
  * Official docs: <https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html>
* Cachix: <https://www.cachix.org>
* Nix Direnv: <https://github.com/nix-community/nix-direnv>
* Direnv: <https://direnv.net/>

## Installing NixOS

1. Boot into a live NixOS environment (either a live USB containing the [NixOS
installer](https://nixos.org/download.html#nixos-iso) or an existing NixOS installation on another drive)
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
