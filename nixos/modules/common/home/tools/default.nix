{ pkgs, ... }:

{
  imports = [ ./lsp ];
  home.packages = [
    pkgs.xclip
    pkgs.btop
    pkgs.ranger
    pkgs.lazygit
    pkgs.duf
    pkgs.du-dust
    pkgs.tre-command
    pkgs.neofetch
  ];
}
