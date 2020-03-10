#!/bin/sh
set -eu
dir=$(CDPATH='' cd -- "$(dirname -- "$0")"/.. && pwd -P)
# shellcheck source=install/detect_os.sh

IMAGE="$1"

docker build -t "zlx/${IMAGE}_dev" -f- "$dir" <<EOF
FROM $IMAGE

# Copy individual scripts as needed to improve docker layer caching
COPY install/detect_os.sh install/diff-so-fancy.sh /dotfiles/install/
RUN /dotfiles/install/diff-so-fancy.sh --docker

COPY install/fish.sh /dotfiles/install/
RUN /dotfiles/install/fish.sh

COPY install/nvim.sh /dotfiles/install/
COPY .config/nvim/init.vim /dotfiles/.config/nvim/init.vim
RUN /dotfiles/install/nvim.sh

# Copy the rest of the files in one go, as there's nothing left
# that could benefit from caching.
COPY . /dotfiles/
RUN /dotfiles/install/dotfiles.sh
EOF
