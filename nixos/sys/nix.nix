{ pkgs, ... }:
{
  nix = {
    package = pkgs.nix_2_7;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
