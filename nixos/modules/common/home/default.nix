{ pkgs, ... }: {
  imports = [ ./terminal ./zsh ./neovim ./cli-tools ./env ./theme ./android ];
  home.packages = with pkgs; [ sqlite-web qbittorrent inkscape gimp ];
}
