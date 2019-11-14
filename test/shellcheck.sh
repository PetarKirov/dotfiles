#!/bin/sh

set -eu

dir="$(CDPATH='' cd -- "$(dirname -- "$0")"/.. && pwd -P)"

for f in "$dir"/install/*.sh "$dir"/test/shellcheck.sh; do
    if ls "$f" 1> /dev/null 2>&1; then
        echo "Checking '$f' with shellcheck..."
        shellcheck -x "$f"
    fi
done

