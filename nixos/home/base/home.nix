{
  config,
  pkgs,
  username,
  ...
}: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };

  manual.manpages.enable = false;

  programs = {
    home-manager.enable = true;
    bash.enable = true;
    direnv.enable = true;
  };

  home.sessionVariables = rec {
    DIRENV_WARN_TIMEOUT = "30s";
    CODE = "${config.home.homeDirectory}/code";
    TMPCODE = "${CODE}/tmp";
    REPOS = "${CODE}/repos";
    CFG = "${REPOS}/dotfiles";
    DLANG = "${REPOS}/dlang";
    WORK = "${REPOS}/metacraft-labs";
  };
}
