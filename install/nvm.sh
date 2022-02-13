#!/bin/sh
set -eu
dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
# shellcheck source=install/detect_os.sh
. "$dir/detect_os.sh"

if [ "$OS" = 'linux' ] || [ "$OS" = 'osx' ]; then
	if [ "$DIST" = 'ubuntu' ] || [ "$DIST" = 'debian' ]; then
		$SUDO apt-get update
		$SUDO apt-get install bash curl -y
	elif [ "$DIST" = 'arch' ]; then
		$SUDO pacman -Sy bash curl --noconfirm
	elif [ "$DIST" = 'alpine' ]; then
		$SUDO apk add bash curl
	elif [ "$DIST" = 'homebrew' ]; then
		brew install bash curl
	fi
    url="https://github.com/nvm-sh/nvm/raw/v0.34.0/install.sh"
    curl -fsSL "$url" | /usr/bin/env bash

    if type fish >/dev/null 2>&1 && fish -c 'type omf' >/dev/null 2>&1; then
        fish -c 'omf install https://github.com/edc/bass'
        fish -c 'omf install https://github.com/FabioAntunes/fish-nvm'
    fi
fi
