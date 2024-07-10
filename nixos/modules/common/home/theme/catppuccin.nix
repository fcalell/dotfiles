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
  };
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.size = 24;
}
