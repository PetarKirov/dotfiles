{
  config,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.lib.mkOverride 1 pkgs.linuxKernel.packages.linux_5_15;
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;

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
