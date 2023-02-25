{hostname, ...}: {
  networking.hostName = hostname;
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../sys/imports.nix
    (./. + "/${hostname}/configuration.nix")
    (./. + "/${hostname}/hardware-configuration.nix")
  ];
}
