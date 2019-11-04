#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname ${BASH_SOURCE[0]})"
. "$DIR/detect_os.bash"

flutter_channel='stable'
repo_dir="$HOME/code/repos/flutter"
linux_packages=(curl git tar unzip)

set -x

if [ "$DIST" == 'ubuntu' ] || [ "$DIST" == 'debian' ]; then
    $SUDO apt update
    $SUDO apt-get install "${linux_packages[@]}" xz-utils -yy
elif [ "$DIST" == 'arch' ]; then
    $SUDO pacman -Sy "${linux_packages[@]}" which xz --noconfirm
elif [ "$OS" == 'osx' ]; then
    brew install bash curl git unzip
fi

git clone -b "$flutter_channel" https://github.com/flutter/flutter.git "$repo_dir"
"$repo_dir/bin/flutter" precache
"$repo_dir/bin/flutter" doctor -v
