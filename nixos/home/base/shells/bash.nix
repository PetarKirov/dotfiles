{pkgs, ...}: {
  programs.bash.enable = true;
  home.packages = with pkgs; [bash];
}
