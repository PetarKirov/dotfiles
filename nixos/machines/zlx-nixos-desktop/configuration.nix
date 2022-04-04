{pkgs, ...}: {
  boot.kernelPackages = pkgs.lib.mkOverride 0 pkgs.linuxKernel.packages.linux_5_16;
  system.stateVersion = "20.03";
}
