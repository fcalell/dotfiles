{ inputs, ... }:
let
  accent = "blue";
  flavor = "mocha";
in {
  imports = [ inputs.catppuccin.homeModules.catppuccin ];
  catppuccin = {
    enable = true;
    accent = accent;
    flavor = flavor;
    # Waybar
    waybar.mode = "createLink";
    # Deprecated
    # gtk = {
    #   enable = true;
    #   accent = accent;
    #   flavor = flavor;
    # };
  };
}
