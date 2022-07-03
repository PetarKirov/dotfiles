{
  pkgs,
  defaultUser,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.stable;
    trustedUsers = ["root" defaultUser];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
