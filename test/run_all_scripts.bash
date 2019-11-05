#!/usr/bin/env bash

set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
IMAGE="$1"
set -x
DISABLED_TEST_BUNDLES=(${2:-})

if [ "$IMAGE" != 'NATIVE' ]; then
    docker build --network=host \
        -t "my_$IMAGE" \
        -f "$DIR/test/docker/${IMAGE}.Dockerfile" \
        "$DIR"
fi

for bundle in $DIR/test/bundles/*; do
    bundle_name=$(basename $bundle '.bash')
    if [[ " ${DISABLED_TEST_BUNDLES[@]-} " =~ " ${bundle_name} " ]]; then
        continue
    fi
    bundle_relative_path=$(realpath --relative-to="$DIR" "$bundle")
    if [ "$IMAGE" != 'NATIVE' ]; then
        "$DIR/test/install_on_docker.bash" "my_$IMAGE" "$bundle_relative_path"
    else
        "$bundle"
    fi
done
