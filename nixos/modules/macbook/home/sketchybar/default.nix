{ config, pkgs, ... }: {
  home.packages = with pkgs; [ sketchybar ];

  xdg.configFile.".config/sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/sketchybar/config";
  };
}
