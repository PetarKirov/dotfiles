#!/bin/sh

set -eu

dir="$(CDPATH='' cd -- "$(dirname -- "$0")"/.. && pwd -P)"


# shellcheck disable=SC2016
find "$dir" -type f -name '*.sh' -exec /bin/sh -c '
    if ls "$1" 1> /dev/null 2>&1; then
        echo "Checking $1 with shellcheck..."
        shellcheck -x "$1"
    fi
  ' sh {} \;
