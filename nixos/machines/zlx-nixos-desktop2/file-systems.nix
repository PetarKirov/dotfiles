{
  fileSystems."/nix" = {
    device = "zfs_root/nixos/nix";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/etc" = {
    device = "zfs_root/nixos/etc";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var" = {
    device = "zfs_root/nixos/var";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var/lib" = {
    device = "zfs_root/nixos/var/lib";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var/lib/docker" = {
    device = "zfs_root/nixos/var/lib/docker";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home" = {
    device = "zfs_root/userdata/home";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/4d3f92db-47ea-49cd-8ab5-63cb17e8613b";
      randomEncryption = true;
    }
  ];
}
