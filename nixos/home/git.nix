{
  pkgs,
  unstablePkgs,
  ...
}: {
  programs.git = {
    enable = true;
    package = unstablePkgs.gitAndTools.gitFull;
    delta.enable = true;
    includes = [
      {path = ../../.gitconfig;}
      {path = ../../.config/git/aliases.gitconfig;}
      {path = ../../.config/git/delta.gitconfig;}
      {path = ../../.config/git/delta-themes.gitconfig;}
    ];
  };
}
