{lib, ...}: {
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["amd_pstate" "kvm-amd"];
  boot.kernelParams = [
    "initcall_blacklist=acpi_cpufreq_init"
  ];
  boot.blacklistedKernelModules = ["nouveau" "nvidia"];
  boot.extraModulePackages = [];

  boot.kernelPatches = [
    {
      name = "enable-pinctrl-amd-for-elan-touchpad";
      patch = null;
      extraConfig = ''
        PINCTRL_AMD y
      '';
    }
  ];

  imports = [./file-systems.nix];

  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  powerManagement.cpuFreqGovernor = "schedutil";
}
