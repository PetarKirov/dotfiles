#!/usr/bin/env bash

# Runs all test bundles (defined in test/bundles/) under various Docker containers.
# Total run-time > 23.4 min

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"

set -x

for image_path in $DIR/test/docker/*; do
    image_name=$(basename "$image_path" '.Dockerfile')
    docker build --network=host \
        -t "$image_name" \
        -f "$image_path" \
        "$DIR/test/"
done

for image in 'debian:latest' 'ubuntu:rolling' 'arch_linux' 'linuxbrew'
do
    for bundle in $DIR/test/bundles/*; do
        bundle_relative_path=$(realpath --relative-to="$DIR" "$bundle")
        "$DIR/test/install_on_docker.bash" "$image" "$bundle_relative_path"
    done
done
