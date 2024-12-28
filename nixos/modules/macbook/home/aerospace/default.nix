{ pkgs, config, ... }: {
  home.packages = with pkgs; [ aerospace ];
  launchd.agents.aerospace = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
  xdg.configFile."aerospace/aerospace.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/aerospace/aerospace.toml";
  };
}
