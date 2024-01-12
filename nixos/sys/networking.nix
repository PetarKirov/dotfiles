{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = ["1.1.1.1"];

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
  };

  services = {
    mullvad-vpn.enable = true;
    tailscale.enable = true;
  };
}
