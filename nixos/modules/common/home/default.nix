{ pkgs, ... }: {
  imports = [
    ./terminal
    ./zsh
    ./neovim
    ./cli-tools
    ./env
    ./theme
    ./android
    ./code-cursor
  ];
  home.packages = with pkgs; [ sqlite-web inkscape gimp streamrip ];
}
