{ pkgs, config, ... }: {
  home.packages = with pkgs; [ streamrip ];
  # xdg.configFile."streamrip/config.toml" = {
  #   source = config.lib.file.mkOutOfStoreSymlink
  #     "${config.home.homeDirectory}/nixos/modules/nixos/home/streamrip/config.toml";
  # };
}
