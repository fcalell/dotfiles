{ ... }: {
  services = {
    libinput = {
      enable = true;
      mouse = { accelProfile = "flat"; };
      touchpad = { accelProfile = "flat"; };
    };
    # xserver = {
    #   # enable = true;
    #   # desktopManager = { xfce.enable = true; };
    #   desktopManager = { xterm.enable = false; };
    #   xkb = {
    #     variant = "";
    #     layout = "us";
    #   };
    # };
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
