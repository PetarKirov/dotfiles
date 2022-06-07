#!/usr/bin/env bash

set -euo pipefail

if ! git config --get user.name >/dev/null 2>&1 || \
  [ "$(git config --get user.name)" = "" ] ||
  ! git config --get user.email >/dev/null 2>&1 || \
  [ "$(git config --get user.email)" = "" ]; then
  echo "git config user.{name,email} is not set - configuring"
  set -x
  git config --local user.email "out@space.com"
  git config --local user.name "beep boop"
fi

nix flake update --commit-lock-file
git log -1 '--pretty=format:%b' | sed '1,2d' > commit_msg_body
git reset --soft 'HEAD~'

>> "$GITHUB_ENV" cat <<EOF
COMMIT_MSG<<EOV
chore(flake.lock): Update all Flake inputs ($(date -I))

$(cat ./commit_msg_body)
EOV
EOF
