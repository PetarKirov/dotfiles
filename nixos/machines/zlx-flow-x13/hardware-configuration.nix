{lib, ...}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["amd_pstate" "kvm-amd"];
  boot.kernelParams = [
    "initcall_blacklist=acpi_cpufreq_init"
  ];
  boot.blacklistedKernelModules = ["nouveau" "nvidia"];
  boot.extraModulePackages = [];

  imports = [./file-systems.nix];

  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.video.hidpi.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";
}
