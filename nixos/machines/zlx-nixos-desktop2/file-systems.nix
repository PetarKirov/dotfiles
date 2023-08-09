let
  inherit (import ../lib.nix) zfsFileSystems;
in {
  fileSystems =
    {
      "/boot" = {
        device = "/dev/disk/by-partuuid/3eeaff26-57b4-49d8-9eaf-5392dd3c61ed";
        fsType = "vfat";
      };
    }
    // (zfsFileSystems {
      datasets = [
        "nixos"
        "nixos/nix"
        "nixos/var"
        "nixos/var/lib"
        "nixos/var/lib/docker"
        "userdata/home"
      ];
    });

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/530bb033-6972-4dd5-812e-d8108104bfa5";
      randomEncryption = true;
    }
  ];
}
