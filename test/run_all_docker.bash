#!/usr/bin/env bash

# Runs all test bundles (defined in test/bundles/) under various Docker containers.
# Total run-time > 23.4 min

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"

set -x

for image_path in $DIR/test/docker/*; do
    image_name="my_$(basename "$image_path" '.Dockerfile')"
    docker build --network=host \
        -t "$image_name" \
        -f "$image_path" \
        "$DIR"
done

for image_path in $DIR/test/docker/*;
do
    image_name="my_$(basename "$image_path" '.Dockerfile')"
    for bundle in $DIR/test/bundles/*; do
        bundle_relative_path=$(realpath --relative-to="$DIR" "$bundle")
        "$DIR/test/install_on_docker.bash" "$image_name" "$bundle_relative_path"
    done
done
