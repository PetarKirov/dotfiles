#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"

cp -v "$DIR/.gitconfig" "$HOME"
cp -Rv "$DIR/.config" "$HOME"
