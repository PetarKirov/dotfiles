{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.lib.mkOverride 1 pkgs.linuxPackages;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Reference:
  # * https://wiki.archlinux.org/index.php/Linux_console
  # * https://alexandre.deverteuil.net/docs/archlinux-consolefonts/
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
