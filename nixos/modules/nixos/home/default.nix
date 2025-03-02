{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ./streamrip ];
  home.packages = with pkgs; [
    google-chrome
    xfce.thunar
    xfce.tumbler
    onlyoffice-bin
    vlc
    nicotine-plus
  ];
}
