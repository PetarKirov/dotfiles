#!/bin/sh

dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
# shellcheck source=install/detect_os.sh
. "$dir/detect_os.sh"

if [ "$DIST" = 'ubuntu' ] || [ "$DIST" = 'debian' ]; then
    $SUDO apt-get update
    $SUDO apt-get install curl git -yy

    if [ "$DIST" = 'ubuntu' ]; then
        $SUDO apt-get install software-properties-common -y
        $SUDO add-apt-repository ppa:neovim-ppa/unstable -y
        $SUDO apt-get update
        $SUDO apt-get install neovim -yy
    else
        $SUDO echo 'deb http://deb.debian.org/debian/ testing main' > /etc/apt/sources.list.d/debian-testing.list
        $SUDO echo 'APT::Default-Release "stable";' > /etc/apt/apt.conf.d/99defaultrelease
        $SUDO apt-get update
        $SUDO apt-get -t testing install neovim -yy
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
