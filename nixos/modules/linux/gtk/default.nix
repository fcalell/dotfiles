{ pkgs, ... }:
let
  catppuccin = pkgs.catppuccin-gtk.override {
    size = "compact";
    accents = [ "blue" ];
    variant = "macchiato";
  };
in {
  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
      size = 32; # Affects gtk applications as the name suggests
    };

    theme = {
      name = "Catppuccin-Macchiato-Compact-Blue-dark";
      package = catppuccin;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-folders;
    };
  };
  home.file.".config/gtk-4.0/gtk.css".source =
    "${catppuccin}/share/themes/Catppuccin-Mocha-Standard-Maroon-Dark/gtk-4.0/gtk.css";
  home.file.".config/gtk-4.0/gtk-dark.css".source =
    "${catppuccin}/share/themes/Catppuccin-Mocha-Standard-Maroon-Dark/gtk-4.0/gtk-dark.css";
  home.file.".config/gtk-4.0/assets" = {
    recursive = true;
    source =
      "${catppuccin}/share/themes/Catppuccin-Mocha-Standard-Maroon-Dark/gtk-4.0/assets";
  };

}
