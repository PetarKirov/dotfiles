#!/bin/sh

dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
# shellcheck source=install/detect_os.sh
. "$dir/detect_os.sh"

if [ "$DIST" = 'ubuntu' ] || [ "$DIST" = 'debian' ]; then
    if [ "$DIST" != 'debian' ]; then
        # NeoVim is part of Debian, while on Ubuntu we need to add a PPA
        $SUDO apt-get update
        $SUDO apt-get install software-properties-common -y
        $SUDO add-apt-repository ppa:neovim-ppa/unstable -y
    fi
    if grep -q stretch /etc/os-release; then
        # Debian Stretch comes with a super outdated version of neovim
        $SUDO echo "deb http://deb.debian.org/debian stretch-backports main" \
            >> /etc/apt/sources.list
        $SUDO apt-get update
        $SUDO apt-get -t stretch-backports install neovim -y
        $SUDO apt-get install curl git -y
    else
        $SUDO apt-get update
        $SUDO apt-get install curl git neovim -y
    fi
elif [ "$DIST" = 'arch' ]; then
    $SUDO pacman -Syu curl git neovim --noconfirm
elif [ "$DIST" = 'alpine' ]; then
    $SUDO apk add curl git neovim
elif [ "$DIST" = 'homebrew' ]; then
    brew install curl git neovim
else
    echo "Unsupported platform: DIST: '$DIST' OS: '$OS'"
    return 13
fi

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$XDG_CONFIG_HOME"

ln -s "$dir/../.config/nvim" "$XDG_CONFIG_HOME/nvim"

curl -fsSL https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh \
  | /bin/sh -s -- "$HOME/.cache/dein"

nvim +"call dein#install()" +qall
