{ pkgs, defaultUser, ... }:
{
  nix = {
    package = pkgs.nix_2_7;
    trustedUsers = [ "root" defaultUser ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
