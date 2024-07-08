{ inputs, ... }:
let
  accent = "blue";
  flavor = "mocha";
in {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
  catppuccin = {
    enable = true;
    accent = accent;
    flavor = flavor;
    pointerCursor = {
      enable = true;
      accent = "dark";
      flavor = flavor;
    };
  };
  gtk = {
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
}
