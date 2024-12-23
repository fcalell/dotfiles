{ pkgs, config, ... }: {
  home.packages = with pkgs; [ aerospace jankyborders sketchybar ];

  xdg.configFile."aerospace/aerospace.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/aerospace/aerospace.toml";
  };
}
