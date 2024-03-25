{ pkgs, ... }:

{
  imports = [
    ./terminal
    ./zsh
    ./neovim
    ./cli-tools
    ./fonts
    ./env
    # ./android 
  ];
  home.packages = [ pkgs.google-chrome ];
}
