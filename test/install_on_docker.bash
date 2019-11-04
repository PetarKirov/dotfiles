#!/usr/bin/env bash

set -euo pipefail

DOCKER_IMAGE="${1:-debian}"
TEST="${2:-install/nvim.bash}"

set -x

docker run --network=host -it \
    "$DOCKER_IMAGE" \
    /bin/bash "/scripts/$TEST"
