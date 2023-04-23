NIX_PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin"

# Ensure that the Nix PATH is at the start (has higher priority).
# Needed to avoid the following error:
# xcode-select: note: no developer tools were found at '/Applications/Xcode.app', requesting install
# which occurs when git is `/usr/bin/git`.
if [[ "$PATH" == *:$NIX_PATH ]]; then
  PATH_WITHOUT_NIX="${PATH%":$NIX_PATH"}"
  export PATH="$NIX_PATH:$PATH_WITHOUT_NIX"
fi
