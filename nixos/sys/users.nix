{
  pkgs,
  username,
  ...
}: {
  # Ensure the plugdev group exists, so it could be used for udev rules
  users.groups.plugdev = {};

  users.users."${username}" = {
    shell = pkgs.fish;
    initialPassword = "";
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "plugdev" "libvirtd"];
  };
}
