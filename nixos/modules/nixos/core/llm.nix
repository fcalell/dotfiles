{ pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.amdgpu.opencl.enable = true;
  nixpkgs.config.rocmSupport = true;
  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    clinfo
    rocmPackages.clr.icd
    nvtop-amd
    lmstudio
  ];
}
