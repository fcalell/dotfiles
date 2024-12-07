{ username, pkgs, ... }: {
  boot.kernelModules = [ "amdgpu" ];
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
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  nixpkgs.config.rocmSupport = true;
  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    clinfo
    nvtopPackages.amd
  ];

  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [ rocblas hipblas clr ];
    };
  in [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];

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
