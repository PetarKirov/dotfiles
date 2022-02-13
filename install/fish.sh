#!/bin/sh
set -eu
dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
# shellcheck source=install/detect_os.sh
. "$dir/detect_os.sh"

fish_debian_repo="http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_9.0"

if [ "$DIST" = 'ubuntu' ] || [ "$DIST" = 'debian' ]; then
    $SUDO apt-get update
    $SUDO apt-get install curl git gnupg2 software-properties-common -y
    if [ "$DIST" = 'ubuntu' ]; then
        $SUDO add-apt-repository ppa:fish-shell/release-3 -y
    elif [ "$DIST" = 'debian' ]; then
        $SUDO add-apt-repository "deb $fish_debian_repo /" -y
        curl -fsSL "$fish_debian_repo/Release.key" | $SUDO apt-key add -
    else
        exit 13
    fi
    $SUDO apt update
    $SUDO apt-get install fish -y
elif [ "$DIST" = 'arch' ]; then
    $SUDO pacman -Syu curl git tar which fish --noconfirm
elif [ "$DIST" = 'alpine' ]; then
    $SUDO apk add curl git tar fish
elif [ "$DIST" = 'homebrew' ]; then
    brew install curl git fish
else
    echo "Unsupported platform: DIST: '$DIST' OS: '$OS'"
    return 13
fi

curl -fsSL https://get.oh-my.fish > install_omf.fish \
    && fish install_omf.fish --noninteractive --channel=dev \
    && rm install_omf.fish \
    && fish -c 'omf install bobthefish'
