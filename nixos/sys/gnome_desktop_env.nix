{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Needed for Home Manager to be able to update DConf settings
  # See: https://github.com/nix-community/home-manager/blob/f911ebbec927e8e9b582f2e32e2b35f730074cfc/modules/misc/dconf.nix#L25-L26
  programs.dconf.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
      	["bluez5.enable-sbc-xq"] = true,
      	["bluez5.enable-msbc"] = true,
      	["bluez5.enable-hw-volume"] = true,
      	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
}
