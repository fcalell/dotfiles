{ pkgs, ... }:

{
  imports = [
    ./terminal
    ./browser
    ./zsh
    ./neovim
    ./cli-tools
    ./fonts
    ./env
    # ./android 
  ];
  home.packages = [ pkgs.google-chrome ];
}
