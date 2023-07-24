{pkgs, ...}: {
  imports = [
    ../base
  ];

  home.packages = with pkgs; [
    openssh
  ];
}
