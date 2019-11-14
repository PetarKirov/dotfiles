#!/usr/bin/env bash

set -euo pipefail

DOCKER_IMAGE="${1:-debian}"
TEST="${2:-install/nvim.sh}"

set -x

docker run --network=host \
    "$DOCKER_IMAGE" \
    /bin/sh "/scripts/$TEST"
