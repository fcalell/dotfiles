{ pkgs, ... }:

{
  imports = [ ./android ./terminal ./zsh ./neovim ./cli-tools ./fonts ./env ];
  home.packages = [ pkgs.google-chrome ];
}
