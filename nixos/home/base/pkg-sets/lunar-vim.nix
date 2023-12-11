{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    lunarvim
  ];

  xdg.configFile."lvim".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.sessionVariables.CFG}/.config/lvim";
}
