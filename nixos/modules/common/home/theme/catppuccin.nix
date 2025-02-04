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
    cursors = {
      enable = true;
      accent = "dark";
      flavor = flavor;
    };
    # gtk = {
    #   enable = true;
    #   accent = accent;
    #   flavor = flavor;
    # };
  };
}
