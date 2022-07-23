with builtins; let
  zfsRoot = "zfs_root";
  splitPath = path: filter (x: (typeOf x) == "string") (split "/" path);
  pathTail = path: concatStringsSep "/" (tail (splitPath path));
  makeZfs = zfsDataset: {
    name = "/" + pathTail zfsDataset;
    value = {
      device = "${zfsRoot}/${zfsDataset}";
      fsType = "zfs";
      options = ["zfsutil"];
    };
  };
  zfsFileSystems = datasetList: listToAttrs (map makeZfs datasetList);
in {
  fileSystems =
    {
      "/boot" = {
        device = "/dev/disk/by-partuuid/55530fca-cd84-4bba-9345-410de7a30fff";
        fsType = "vfat";
      };
    }
    // zfsFileSystems [
      "nixos"
      "nixos/nix"
      "nixos/var"
      "nixos/var/lib"
      "nixos/var/lib/docker"
      "userdata/home"
    ];

  swapDevices = [];
}
