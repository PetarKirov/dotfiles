#!/usr/bin/env bash

set -euxo pipefail

git config --local user.email "out@space.com"
git config --local user.name "beep boop"

nix flake update --commit-lock-file
git log -1 '--pretty=format:%b' | sed '1,2d' > commit_msg_body
git reset --soft 'HEAD~'

>> "$GITHUB_ENV" cat <<EOF
COMMIT_MSG<<EOV
chore(flake.lock): Update all Flake inputs ($(date -I))

$(cat ./commit_msg_body)
EOV
EOF
