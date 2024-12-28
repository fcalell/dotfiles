{ pkgs, ... }: {
  # imports = [ ./aerospace ./sketchybar ];
  home.packages = with pkgs; [ gnused nicotine-plus cocoapods ];
}
