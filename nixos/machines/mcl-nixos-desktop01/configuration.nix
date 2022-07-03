{
  networking.hostId = "8a1ab9b7";
  system.stateVersion = "22.05";

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = ["zfs_root"];
  };
}
