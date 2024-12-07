{ username, pkgs, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.amdgpu = {
    opencl.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
      supportExperimental.enable = true;
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  nixpkgs.config.rocmSupport = true;
  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    clinfo
    nvtopPackages.amd
    rocmPackages.clr.icd
  ];
  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
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
      enable = true;
      videoDrivers = [ "amdgpu" ];
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
