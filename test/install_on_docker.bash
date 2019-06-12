#!/usr/bin/env bash

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"

DOCKER_IMAGE="${1:-debian}"
TEST="${2:-install/nvim.bash}"

set -x

docker run --network=host -it \
    -v "$DIR:/scripts" "$DOCKER_IMAGE" \
    /bin/bash "/scripts/$TEST"
