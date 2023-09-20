{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  username =
    if args ? username
    then args.username
    else "!";
in {
  home = {
    username = lib.mkIf (args ? username) username;
    homeDirectory =
      lib.mkIf (args ? username)
      (
        if pkgs.hostPlatform.isDarwin
        then "/Users/${username}"
        else "/home/${username}"
      );
    stateVersion = "22.11";
  };

  manual.manpages.enable = false;
  programs.home-manager.enable = true;
}
