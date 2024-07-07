{ config, ... }: {
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      accent = config.catppuccin.accent;
      flavor = config.catppuccin.flavor;
      icon = {
        enable = true;
        accent = config.catppuccin.accent;
        flavor = config.catppuccin.flavor;
      };
      tweaks = [ "black" "rimless" ];
    };
  };

  # home.sessionVariables = {
  #   # GTK_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
  #   # GTK4_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
  #   GTK_ICON_THEME = "Papirus-Dark";
  #   GTK_CURSOR_THEME = "Catppuccin-Mocha-Dark-Cursors";
  #   DISABLE_QT5_COMPAT = "0";
  #   NIXOS_OZONE_WL = "1";
  # };
}
