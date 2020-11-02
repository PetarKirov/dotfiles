{ pkgs, ...}:
{
  # Ensure the plugdev group exists, so it could be used for udev rules
  users.groups.plugdev = {};

  programs.fish.enable = true;

  users.users.zlx = {
    shell = pkgs.fish;
    initialPassword = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "plugdev" ];
  };
}
