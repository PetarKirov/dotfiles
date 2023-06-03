{lib, ...}: {
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  imports = [./file-systems.nix];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
