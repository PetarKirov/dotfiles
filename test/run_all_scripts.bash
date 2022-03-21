#!/usr/bin/env bash

set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
IMAGE="$1"
DISABLED_TEST_BUNDLES=(${2:-})

if [ "$IMAGE" != 'NATIVE' ]; then
    echo "::group::Building Docker image: ${IMAGE}"
    set -x
    docker build --network=host \
        -t "my_$IMAGE" \
        -f "$DIR/test/docker/${IMAGE}.Dockerfile" \
        "$DIR"
    set +x
    echo "::endgroup::"
fi

cd $DIR

for bundle in ./test/bundles/*; do
    bundle_name=$(basename $bundle '.sh')
    if [[ " ${DISABLED_TEST_BUNDLES[@]-} " =~ " ${bundle_name} " ]]; then
        echo "Skipping test bundle: ${bundle_name}."
        continue
    fi
    echo "::group::Running bundle: ${bundle_name}"
    if [ "$IMAGE" != 'NATIVE' ]; then
        set -x
        "$DIR/test/install_on_docker.bash" "my_$IMAGE" "$bundle"
        set +x
    else
        set -x
        "$bundle"
        set +x
    fi
    echo "::endgroup::"
done
