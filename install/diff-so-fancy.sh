#!/bin/sh
set -eu
dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
# shellcheck source=install/detect_os.sh
. "$dir/detect_os.sh"

# Install dependencies

if [ "$DIST" = 'ubuntu' ] || [ "$DIST" = 'debian' ]; then
    $SUDO apt-get update
    if [ "${1:-}" = '--docker' ]; then
        # setup locales for ubuntu/debian dev container
        $SUDO apt-get install less curl perl locales -y
        echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
        dpkg-reconfigure --frontend=noninteractive locales
        locale-gen en_US.UTF-8
        update-locale LANG=en_US.UTF-8
    else
        $SUDO apt-get install less curl perl -y
    fi
elif [ "$DIST" = 'arch' ]; then
    $SUDO pacman -Sy less curl perl --noconfirm
elif [ "$DIST" = 'alpine' ]; then
    $SUDO apk add less curl perl ncurses
elif [ "$DIST" = 'homebrew' ]; then
    brew install less curl perl
fi

url="https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
dir="$HOME/.local/bin"

mkdir -p "$dir"
curl -fsSL $url > "$dir/diff-so-fancy"
chmod 755 "$dir/diff-so-fancy"
