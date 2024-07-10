{ ... }:
let
  accent = "blue";
  flavor = "mocha";
in {
  catppuccin = {
    pointerCursor = {
      enable = true;
      accent = "dark";
      flavor = flavor;
    };
  };
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      accent = accent;
      flavor = flavor;
      icon = {
        enable = true;
        accent = accent;
        flavor = flavor;
      };
      tweaks = [ "rimless" ];
    };
  };
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.size = 24;

  # home.sessionVariables = {
  #   # GTK_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
  #   # GTK4_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
  #   GTK_ICON_THEME = "Papirus-Dark";
  #   GTK_CURSOR_THEME = "Catppuccin-Mocha-Dark-Cursors";
  #   DISABLE_QT5_COMPAT = "0";
  #   NIXOS_OZONE_WL = "1";
  # };
}
