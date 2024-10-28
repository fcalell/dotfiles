{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      # name = "Adwaita-dark";
      # package = pkgs.gnome-themes-extra;
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
    gtk3.extraCss = builtins.readFile ./gtk-3.0/gtk.css;
    gtk4.extraCss = builtins.readFile ./gtk-4.0/gtk.css;
  };
  home.pointerCursor.gtk.enable = true;
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    };
  };

  home.packages = with pkgs; [ gsettings-desktop-schemas ];
  home.sessionVariables = {
    XDG_DATA_DIRS =
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS";
    #   # GTK_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
    #   # GTK4_THEME = "Catppuccino-Mocha-Compact-Blue-Dark";
    #   GTK_ICON_THEME = "Papirus-Dark";
    #   GTK_CURSOR_THEME = "Catppuccin-Mocha-Dark-Cursors";
    #   DISABLE_QT5_COMPAT = "0";
    #   NIXOS_OZONE_WL = "1";
  };
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
