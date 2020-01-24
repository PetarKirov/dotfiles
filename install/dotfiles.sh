#!/bin/sh

set -eu

dir=$(CDPATH='' cd -- "$(dirname -- "$0")"/.. && pwd -P)

cp -vp "$dir/.gitconfig" "$HOME"
cp -Rvp "$dir/.config" "$HOME"
