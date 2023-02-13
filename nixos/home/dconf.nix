# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}: let
  mkTuple = lib.hm.gvariant.mkTuple;
in {
  dconf.settings = {
    "com/gexperts/Tilix" = {
      control-scroll-zoom = true;
      terminal-title-style = "none";
      window-style = "normal";
    };

    "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
      default-size-columns = 150;
      default-size-rows = 36;
      font = "FiraCode Nerd Font Mono weight=450 12";
      scrollback-unlimited = true;
      use-system-font = false;
      visible-name = "Default";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [];
      switch-applications-backward = [];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>t";
      command = "tilix";
      name = "Open Terminal";
    };

    "org/gnome/desktop/input-sources" = {
      current = "uint32 0";
      per-window = false;
      sources = [(mkTuple ["xkb" "us"]) (mkTuple ["xkb" "bg+phonetic"])];
      xkb-options = ["terminate:ctrl_alt_bksp"];
    };

    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      cursor-theme = "Yaru";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Yaru-dark";
      icon-theme = "Yaru";
    };
  };
}
