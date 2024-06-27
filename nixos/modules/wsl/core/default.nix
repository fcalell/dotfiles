{ inputs, ... }: {
  imports = [ inputs.nixos-wsl.nixosModules.wsl ./user.nix ];

  wsl.enable = true;
  wsl.defaultUser = "fcalell";
  wsl.useWindowsDriver = true;
  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  programs.dconf.enable = true;
}
