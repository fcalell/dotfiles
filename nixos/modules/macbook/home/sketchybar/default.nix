{ pkgs, ... }:
let sbarlua = import ./sketchybar-lua.nix { inherit pkgs; };
in {
  home.packages = [ pkgs.sketchybar sbarlua ];

  xdg.configFile."sketchybar" = {
    source = ./config;
    recursive = true;
  };
  xdg.configFile."sketchybar/sketchybar.so" = {
    source = "${sbarlua}/sketchybar.so";
  };
}
