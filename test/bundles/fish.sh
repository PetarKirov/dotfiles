#!/bin/sh
set -eu
dir=$(CDPATH='' cd -- "$(dirname -- "$0")"/../.. && pwd -P)

"$dir/install/fish.sh"
