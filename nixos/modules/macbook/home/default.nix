{ pkgs, ... }: {
  imports = [ ./aerospace ];
  home.packages = with pkgs; [ gnused nicotine-plus cocoapods ];
}
