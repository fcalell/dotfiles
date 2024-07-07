{ pkgs, ... }: {
  imports = [ ./catppuccin.nix ];
  config.theme = {
    fonts = {
      size = 12;
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji;
      };
    };
    background = ./wallpapers/feet-on-the-dashboard.png;
  };
}
