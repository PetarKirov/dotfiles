#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname ${BASH_SOURCE[0]})"
. "$DIR/detect_os.bash"

if [ "$DIST" == 'ubuntu' ] || [ "$DIST" == 'debian' ]; then
    if [ "$DIST" != 'debian' ]; then
        # NeoVim is part of Debian, while on Ubuntu we need to add a PPA
        $SUDO apt-get update
        $SUDO apt-get install software-properties-common -y
        $SUDO add-apt-repository ppa:neovim-ppa/unstable -y
    fi
    $SUDO apt-get update
    $SUDO apt-get install curl git neovim -y
elif [ "$DIST" == 'arch' ]; then
    $SUDO pacman -Syu curl git neovim --noconfirm
elif [ "$DIST" == 'alpine' ]; then
    $SUDO apk add curl git neovim
elif [ "$OS" == 'osx' ]; then
    brew install curl git neovim
fi

curl -fsSL https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh \
  | bash -s -- "$HOME/.cache/dein"
