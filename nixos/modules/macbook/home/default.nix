{ pkgs, ... }: {
  imports = [ ./aerospace ./sketchybar ./jankyborders.nix ];
  home.packages = with pkgs; [ gnused nicotine-plus cocoapods ];
}
