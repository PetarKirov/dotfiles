{lib, ...}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  imports = [./file-systems.nix];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.video.hidpi.enable = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
