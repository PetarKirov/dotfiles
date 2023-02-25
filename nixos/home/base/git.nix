{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.git.override {
      withSsh = true;
      withLibsecret = true;
      sendEmailSupport = true;
    };
    delta.enable = true;
    includes = [
      {path = ../../../.gitconfig;}
      {path = ../../../.config/git/aliases.gitconfig;}
      {path = ../../../.config/git/delta.gitconfig;}
      {path = ../../../.config/git/delta-themes.gitconfig;}
    ];
  };
}
