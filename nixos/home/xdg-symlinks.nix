{config, ...}: {
  # Symlink the whole .config/nvim directory:
  xdg.configFile.nvim.source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.sessionVariables.CFG}/.config/nvim";

  # Symlink `functions` folder, but not the whole `fish` directory, as it
  # contains files generated by both Nix and Fish:
  xdg.configFile."fish/functions".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.sessionVariables.CFG}/.config/fish/functions";
}
