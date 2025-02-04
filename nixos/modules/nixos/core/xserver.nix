{ username, pkgs, ... }: {
  hardware.amdgpu = { opencl.enable = true; };
  hardware.graphics = { enable = true; };
  nixpkgs.config.rocmSupport = true;

  services = {
    libinput = {
      enable = true;
      mouse = { accelProfile = "flat"; };
      touchpad = { accelProfile = "flat"; };
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "${username}";
      };
    };
    xserver = {
      # enable = true;
      # desktopManager = { xfce.enable = true; };
      desktopManager = { xterm.enable = false; };
      xkb = {
        variant = "";
        layout = "us";
      };
    };
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
