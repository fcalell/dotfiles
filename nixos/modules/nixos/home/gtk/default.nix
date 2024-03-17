{ pkgs, ... }: {
  gtk = {
    enable = true;
    font = {
      name = "DroidSansMono Nerd Font";
      size = 12;
    };
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
      size = 32; # Affects gtk applications as the name suggests
    };
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        size = "compact";
        accents = [ "blue" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
  };
  home.sessionVariables = {
    GTK_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
    GTK4_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
    GTK_ICON_THEME = "Papirus-Dark";
    GTK_CURSOR_THEME = "macOS-BigSur";
    DISABLE_QT5_COMPAT = "0";
    NIXOS_OZONE_WL = "1";
  };
  # xdg.configFile = {
  #   "gtk-4.0/assets".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
  #   "gtk-4.0/gtk.css".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
  #   "gtk-4.0/gtk-dark.css".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  # };
}
