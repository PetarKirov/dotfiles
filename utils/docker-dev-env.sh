#!/bin/sh
set -eu
dir=$(CDPATH='' cd -- "$(dirname -- "$0")"/.. && pwd -P)
# shellcheck source=install/detect_os.sh

IMAGE="$1"

docker build -t "zlx/${IMAGE}_dev" -f- "$dir" <<EOF
FROM $IMAGE
COPY . /dotfiles
RUN /dotfiles/install/nvim.sh
RUN /dotfiles/install/fish.sh
RUN /dotfiles/install/dotfiles.sh
RUN /dotfiles/install/diff-so-fancy.sh
EOF
