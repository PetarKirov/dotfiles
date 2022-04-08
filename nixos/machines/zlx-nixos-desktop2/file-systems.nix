let
  zfs_root = "zfs_root";

  make_zfs_fs = {
    mountpoint,
    dataset,
  }: let
    mnt =
      if mountpoint == "/"
      then ""
      else mountpoint;
  in {
    name = mountpoint;
    value = {
      device = "${zfs_root}/${dataset}${mnt}";
      fsType = "zfs";
      options = ["zfsutil"];
    };
  };

  make_zfs_file_systems = datasetList: builtins.listToAttrs (builtins.map make_zfs_fs datasetList);
in {
  fileSystems = make_zfs_file_systems [
    {
      dataset = "nixos";
      mountpoint = "/";
    }
    {
      dataset = "nixos";
      mountpoint = "/nix";
    }
    {
      dataset = "nixos";
      mountpoint = "/var";
    }
    {
      dataset = "nixos";
      mountpoint = "/var/lib";
    }
    {
      dataset = "nixos";
      mountpoint = "/var/lib/docker";
    }
    {
      dataset = "userdata";
      mountpoint = "/home";
    }
  ];

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/530bb033-6972-4dd5-812e-d8108104bfa5";
      randomEncryption = true;
    }
  ];
}
