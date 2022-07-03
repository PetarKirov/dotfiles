{
  networking.hostId = "54b9ab63";
  system.stateVersion = "21.11";

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = ["zfs_root"];
  };
}
