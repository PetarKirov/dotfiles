{
  pkgs,
  defaultUser,
  ...
}: {
  # Ensure the plugdev group exists, so it could be used for udev rules
  users.groups.plugdev = {};

  users.users."${defaultUser}" = {
    shell = pkgs.fish;
    initialPassword = "";
    isNormalUser = true;
    extraGroups = ["wheel" "podman" "docker" "plugdev" "libvirtd"];
  };
}
