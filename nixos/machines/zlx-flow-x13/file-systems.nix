let
  inherit (import ../lib.nix) zfsFileSystems;
in {
  fileSystems =
    {
      "/boot" = {
        device = "/dev/disk/by-partuuid/55530fca-cd84-4bba-9345-410de7a30fff";
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
        "nixos/var/lib/containers"
        "userdata/home"
      ];
    });

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/05b637d9-a94b-4ac0-a1de-2bd51a23366a";
      randomEncryption = true;
    }
  ];
}
