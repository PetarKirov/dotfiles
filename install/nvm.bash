#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname ${BASH_SOURCE[0]})"
. "$DIR/detect_os.bash"

if [ "$OS" == 'linux' ] || [ "$OS" == 'osx' ]; then
	if [ "$DIST" == 'ubuntu' ] || [ "$DIST" == 'debian' ]; then
		$SUDO apt-get update
		$SUDO apt-get install curl -y
	elif [ "$DIST" == 'arch' ]; then
		$SUDO pacman -Sy curl --noconfirm
	elif [ "$OS" == 'osx' ]; then
		brew install curl
	fi
    url="https://github.com/nvm-sh/nvm/raw/v0.34.0/install.sh"
    curl -fsSL "$url" | bash

    if type fish >/dev/null 2>&1 && fish -c 'type omf' >/dev/null 2>&1; then
        fish -c 'omf install https://github.com/edc/bass'
        fish -c 'omf install https://github.com/FabioAntunes/fish-nvm'
    fi
fi
