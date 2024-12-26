{ config, pkgs, ... }: {
  home.packages = with pkgs; [ sketchybar import ./sketchybar-lua.nix ];

  xdg.configFile."sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/sketchybar/config";
  };
}
