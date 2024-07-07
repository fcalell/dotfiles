{ pkgs, ... }:
let
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
in {
  home.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-emoji
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ fonts.serif.name ];
      sansSerif = [ fonts.sansSerif.name ];
      monospace = [ fonts.monospace.name ];
      emoji = [ fonts.emoji.name ];
    };
  };
  gtk.font = {
    name = fonts.sansSerif.name;
    size = fonts.size;
  };
  programs.kitty.font = {
    name = fonts.monospace.name;
    size = fonts.size;
  };
}
