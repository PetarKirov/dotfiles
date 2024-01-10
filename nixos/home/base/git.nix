{pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;
    delta.enable = true;
    includes = [
      {path = ../../../.gitconfig;}
      {path = ../../../.config/git/aliases.gitconfig;}
      {path = ../../../.config/git/delta.gitconfig;}
      {path = ../../../.config/git/delta-themes.gitconfig;}
    ];
  };

  home.packages = with pkgs; [
    git-filter-repo
  ];
}
