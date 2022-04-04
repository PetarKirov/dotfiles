{hostname, ...}: {
  networking.hostName = hostname;
  imports = [
    ../sys/imports.nix
    (./. + "/${hostname}/configuration.nix")
    (./. + "/${hostname}/hardware-configuration.nix")
  ];
}
