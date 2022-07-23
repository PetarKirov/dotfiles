{
  networking.hostId = "cc12d73b";
  system.stateVersion = "22.05";

  nixpkgs.config.allowUnfree = true;

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = ["zfs_root"];
  };
}
