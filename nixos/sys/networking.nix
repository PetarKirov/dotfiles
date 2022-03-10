#{ hostName? , ... }:
{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "1.1.1.1" ];

  networking.wireguard.enable = true;
  services.mullvad-vpn.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # networking.wg-quick.interfaces = {
  #  wg-mlvd = {
  #    address = [ "10.65.142.200/32" "fc00:bbbb:bbbb:bb01::2:8ec7/128" ];
  #    dns = [ "193.138.218.74" ];
  #    privateKeyFile = "/home/zlx/wireguard-keys/private2";
  #    peers = [
  #      {
  #        publicKey = "yXn7ziIFrHRgoZlhWRkxoGFb3maolOxOn6sh+OPLdT8=";
  #        allowedIPs = [ "0.0.0.0/0" "::0/0" ];
  #        endpoint = "217.138.221.226:51820";
  #        persistentKeepalive = 15;
  #      }
  #    ];
  #  };
  # };

  # networking.wg-quick.interfaces = {
  #   wg-anonine = {
  #     address = [ "10.130.0.23" ];
  #     dns = [ "1.1.1.1" ];
  #     privateKeyFile = "/home/zlx/wireguard-keys/private";
  #     peers = [
  #       {
  #         publicKey = "VapB5JQNX0hg1iGkcuaqXSZCjVa09d+DCkNPif//hzY=";
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         endpoint = "de-fr.anonine.net:48030";
  #         persistentKeepalive = 15;
  #       }
  #     ];
  #   };
  # };

  # WireGuard demo: http://demo.wireguard.com
  # networking.wireguard.interfaces = {
  #   wg-demo = {
  #     ips = [ "192.168.4.157/24" ];
  #     privateKeyFile = "/home/zlx/wireguard-keys/private";
  #     peers = [
  #       {
  #         publicKey = "JRI8Xc0zKP9kXk8qP84NdUQA04h6DLfFbwJn4g+/PFs=";
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         endpoint = "demo.wireguard.com:12912";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
}
