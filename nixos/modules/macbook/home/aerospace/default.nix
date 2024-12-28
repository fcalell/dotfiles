{ pkgs, lib, config, ... }: {
  home.packages = with pkgs; [ aerospace ];
  launchd.user.agents.aerospace = {
    command =
      "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
  xdg.configFile."aerospace/aerospace.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/aerospace/aerospace.toml";
  };
}
