{ pkgs, ... }: {
  gtk = {
    enable = true;
    # font = {
    #   name = "DroidSansMono Nerd Font";
    #   size = 12;
    # };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24; # Affects gtk applications as the name suggests
    };
    # theme = {
    #   name = "Catppuccin-Mocha-Compact-Blue-Dark";
    #   package = pkgs.catppuccin-gtk.override {
    #     size = "compact";
    #     accents = [ "blue" ];
    #     variant = "mocha";
    #   };
    # };
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.catppuccin-papirus-folders.override {
    #     flavor = "mocha";
    #     accent = "blue";
    #   };
    # };
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
