{
  config,
  pkgs,
  ...
}: {
  hardware.nvidiaOptimus.disable = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Include custom system configuration
    ../../sys/boot.nix
    ../../sys/networking.nix
    ../../sys/i18n.nix
    ../../sys/users.nix
    ../../sys/gnome_desktop_env.nix
    ../../sys/extra_services.nix
    ../../sys/ledger-nano-udev-rules.nix
    ../../sys/packages.nix

    # Include https://github.com/nix-community/home-manager
    <home-manager/nixos>
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
  system.autoUpgrade.enable = true;
}
