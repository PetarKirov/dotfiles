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
      device = "/dev/disk/by-uuid/4d3f92db-47ea-49cd-8ab5-63cb17e8613b";
      randomEncryption = true;
    }
  ];
}
