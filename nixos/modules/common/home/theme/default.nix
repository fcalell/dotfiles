{ pkgs, config, inputs, ... }: {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
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

  fonts.fontconfig = {
    enable = true;
    defaultfonts = {
      serif = [ config.theme.fonts.serif.name ];
      sansSerif = [ config.theme.fonts.sansSerif.name ];
      monospace = [ config.theme.fonts.monospace.name ];
      emoji = [ config.theme.fonts.emoji.name ];
    };
  };

  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "mocha";
    pointerCursor = {
      enable = true;
      accent = "dark";
      flavor = "mocha";
    };
  };
}
