{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ./streamrip ];
  home.packages = with pkgs; [ google-chrome onlyoffice-bin vlc nicotine-plus ];
}
