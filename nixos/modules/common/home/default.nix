{ pkgs, ... }: {
  imports = [ ./terminal ./zsh ./neovim ./cli-tools ./env ./theme ];
  home.packages = with pkgs; [ sqlite-web qbittorrent ];
}
