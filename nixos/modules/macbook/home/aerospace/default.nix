{ config, ... }: {
  services.aerospace.enable = true;
  xdg.configFile."aerospace/aerospace.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/aerospace/aerospace.toml";
  };
}
