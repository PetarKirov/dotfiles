#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname ${BASH_SOURCE[0]})"
. "$DIR/detect_os.bash"

fish_debian_repo="http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_9.0"

if [ "$DIST" == 'ubuntu' ] || [ "$DIST" == 'debian' ]; then
    $SUDO apt-get update
    $SUDO apt-get install curl git gnupg2 software-properties-common -y
    if [ "$DIST" == 'ubuntu' ]; then
        $SUDO add-apt-repository ppa:fish-shell/release-3 -y
    elif [ "$DIST" == 'debian' ]; then
        $SUDO add-apt-repository "deb $fish_debian_repo /" -y
        curl -fsSL "$fish_debian_repo/Release.key" | $SUDO apt-key add -
    fi
    $SUDO apt update
    $SUDO apt-get install fish -y
elif [ "$DIST" == 'arch' ]; then
    $SUDO pacman -Syu curl git tar which fish --noconfirm
elif [ "$OS" == 'osx' ]; then
    brew install curl git fish
fi

fish <(curl -fsSL https://get.oh-my.fish) --noninteractive
fish -c 'omf install bobthefish'
