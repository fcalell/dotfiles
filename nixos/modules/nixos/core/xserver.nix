_:
let username = "fcalell";
in {
  services = {
    xserver = {
      enable = true;
      displayManager.autoLogin = {
        enable = true;
        user = "${username}";
      };
      # desktopManager = { xfce.enable = true; };
      libinput = {
        enable = true;
        mouse = { accelProfile = "flat"; };
        touchpad = { accelProfile = "flat"; };
      };
      xkb = {
        variant = "";
        layout = "us";
      };
    };
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
