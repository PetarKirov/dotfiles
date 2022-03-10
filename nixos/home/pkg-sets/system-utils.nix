{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Networking
    mullvad-vpn

    ## Disk partitioning:
    # gptfdisk parted

    ## Disk recovery:
    ext4magic testdisk

    ## Monitoring:
    # iotop
    # nethogs

    ## Inspecting devices:
    # usbutils pciutils

    ## Archival and compression (unzip is installed via sys/*.nix):
    p7zip unrar
  ];
}
