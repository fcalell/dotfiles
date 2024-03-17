{ pkgs, ... }:

{
  home.packages = [
    pkgs.btop
    pkgs.ranger
    pkgs.lazygit
    pkgs.duf
    pkgs.du-dust
    pkgs.tre-command
    pkgs.neofetch
  ];
}
