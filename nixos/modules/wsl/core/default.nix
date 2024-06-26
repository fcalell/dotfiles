{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
./user.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "fcalell";
  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  
}
