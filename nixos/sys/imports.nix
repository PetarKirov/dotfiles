{
  imports = [
    ./boot.nix
    ./networking.nix
    ./i18n.nix
    ./users.nix
    ./gnome_desktop_env.nix
    ./extra_services.nix
    ./ledger-nano-udev-rules.nix
    ./packages.nix
  ];
}
