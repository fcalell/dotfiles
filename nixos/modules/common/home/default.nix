{ pkgs, ... }:

{
  imports = [ ./terminal ./zsh ./neovim ./cli-tools ./fonts ./env ];
  home.packages = [ pkgs.google-chrome ];
}
