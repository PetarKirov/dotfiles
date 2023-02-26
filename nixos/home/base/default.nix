{
  imports = [
    ./env-vars.nix
    ./git.nix
    ./home.nix
    ./pkg-sets/cli-utils.nix
    ./shells/bash.nix
    ./shells/direnv.nix
    ./shells/fish.nix
    ./shells/nushell.nix
    ./xdg-symlinks.nix
  ];
}
