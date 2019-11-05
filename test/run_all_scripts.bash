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

cd $DIR

for bundle in ./test/bundles/*; do
    bundle_name=$(basename $bundle '.bash')
    if [[ " ${DISABLED_TEST_BUNDLES[@]-} " =~ " ${bundle_name} " ]]; then
        continue
    fi
    if [ "$IMAGE" != 'NATIVE' ]; then
        "$DIR/test/install_on_docker.bash" "my_$IMAGE" "$bundle"
    else
        "$bundle"
    fi
done
