{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ];
  home.packages = with pkgs; [ google-chrome xfce.thunar onlyoffice-bin ];
}
