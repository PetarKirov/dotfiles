#!/bin/sh
set -eu
dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
# shellcheck source=install/detect_os.sh
. "$dir/detect_os.sh"

flutter_channel='stable'
repo_dir="$HOME/code/repos/flutter"

set -x

if [ "$DIST" = 'ubuntu' ] || [ "$DIST" = 'debian' ]; then
    $SUDO apt update
    $SUDO apt-get install curl git tar unzip xz-utils -yy
elif [ "$DIST" = 'arch' ]; then
    $SUDO pacman -Sy curl git tar unzip which xz --noconfirm
elif [ "$DIST" = 'homebrew' ]; then
    brew install bash curl git unzip
else
    echo "Unsupported platform: DIST: '$DIST' OS: '$OS'"
    return 13
fi

git clone -b "$flutter_channel" https://github.com/flutter/flutter.git "$repo_dir"
"$repo_dir/bin/flutter" precache
"$repo_dir/bin/flutter" doctor -v
