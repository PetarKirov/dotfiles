{config, ...}: let
  nuShellCfg = "${config.home.sessionVariables.CFG}/.config/nushell";
in {
  programs.nushell = {
    enable = true;
    envFile.text = ''
      source "${nuShellCfg}/env.nu"
    '';
    configFile.text = ''
      source "${nuShellCfg}/config.nu"
    '';
  };
}
