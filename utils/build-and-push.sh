#!/usr/bin/env bash

set -euxo pipefail

nom build -L --json --no-link \
    .#nixosConfigurations.zlx-flow-x13.config.system.build.toplevel \
    .#nixosConfigurations.mcl-nixos-desktop01.config.system.build.toplevel \
    .#nixosConfigurations.zlx-nixos-desktop2.config.system.build.toplevel \
    .#homeConfigurations.zlx.activationPackage \
    .#devShells.x86_64-linux.default \
  | jq -r '.[].outputs | to_entries[].value' \
  | cachix push petar-kirov-dotfiles
