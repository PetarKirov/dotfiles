{config, ...}: {
  # Symlink the whole .config/nvim directory:
  xdg.configFile.nvim.source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.sessionVariables.CFG}/.config/nvim";
}
