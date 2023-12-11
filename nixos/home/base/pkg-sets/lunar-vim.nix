{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    lunarvim
  ];

  programs.fish.shellAliases = {
    vi = "lvim";
  };

  home.sessionVariables = {EDITOR = "lvim";};

  xdg.configFile."lvim".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.sessionVariables.CFG}/.config/lvim";
}
