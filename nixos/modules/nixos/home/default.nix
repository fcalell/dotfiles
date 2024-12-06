{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ./streamrip ./android ./virtualization.nix ];
  home.packages = with pkgs; [
    google-chrome
    xfce.thunar
    onlyoffice-bin
    vlc
    nicotine-plus
  ];
}
