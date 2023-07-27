{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = ["1.1.1.1"];

  networking.wireguard.enable = true;

  services = {
    mullvad-vpn.enable = true;
    tailscale.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
}
