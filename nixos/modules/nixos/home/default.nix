{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ];
  home.packages = with pkgs; [ google-chrome onlyoffice-bin vlc nicotine-plus ];
}
