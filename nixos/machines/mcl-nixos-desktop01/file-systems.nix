let
  inherit (import ../lib.nix) zfsFileSystems;
in {
  fileSystems =
    {
      "/boot" = {
        device = "/dev/disk/by-partuuid/9a9dda34-d5f7-48e6-b04b-40f0a7dc08bf";
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
      device = "/dev/disk/by-partuuid/6fac31a5-ffea-4db7-a819-eab24ca1f2aa";
      randomEncryption = true;
    }
  ];
}
