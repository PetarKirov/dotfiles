{
  config,
  pkgs,
  ...
}: let
  dockerStorageDriver =
    if config.fileSystems ? "/var/lib/docker" && config.fileSystems."/var/lib/docker".fsType == "zfs"
    then "zfs"
    else "overlay2";

  podmanStorageDriver =
    if config.fileSystems ? "/var/lib/containers" && config.fileSystems."/var/lib/containers".fsType == "zfs"
    then "zfs"
    else "overlay2";
in {
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = dockerStorageDriver;

  virtualisation.containers.storage.settings.storage = {
    driver = podmanStorageDriver;
    graphroot = "/var/lib/containers/storage";
    runroot = "/run/containers/storage";
  };

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = false;
    dockerCompat = false;
    extraPackages = [pkgs.gvisor];
  };

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
}
