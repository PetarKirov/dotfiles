#!/bin/sh

set -eu

url="https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy"
dir="$HOME/.local/bin"

mkdir -p "$dir"
curl -fsSL $url > "$dir/diff-so-fancy"
chmod 755 "$dir/diff-so-fancy"
