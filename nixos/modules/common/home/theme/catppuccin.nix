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
}
