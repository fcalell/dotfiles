{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pavucontrol ];

  security.polkit.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services = {
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        scrollButton = 2;
        scrollMethod = "button";
      };
      touchpad = { accelProfile = "flat"; };
    };
  };

  hardware.keyboard.qmk.enable = true;
  # hardware.bluetooth.enable = true;
  # services.blueman.enable = true;

  hardware.xone.enable = true;
  # hardware.xpadneo.enable = true;
}
