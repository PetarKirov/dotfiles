#!/bin/sh

set -eu

dir=$(CDPATH='' cd -- "$(dirname -- "$0")"/.. && pwd -P)

cp -v "$dir/.gitconfig" "$HOME"
cp -Rv "$dir/.config" "$HOME"
