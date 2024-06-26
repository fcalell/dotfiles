{inputs,...}:{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ./user.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "fcalell";
  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  
}
