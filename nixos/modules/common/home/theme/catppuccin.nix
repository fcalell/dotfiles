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
  # programs.btop.catppuccin = {
  #   enable = true;
  #   flavor = flavor;
  # };
  # programs.kitty.catppuccin = {
  #   enable = true;
  #   flavor = flavor;
  # };
  # programs.lazygit.catppuccin = {
  #   enable = true;
  #   flavor = flavor;
  # };
  # programs.waybar.catppuccin = {
  #   enable = true;
  #   flavor = flavor;
  # };
  # programs.zsh.syntaxHighlighting.catppuccin = {
  #   enable = true;
  #   flavor = flavor;
  # };
  # services.mako.catppuccin = {
  #   enable = true;
  #   flavor = flavor;
  # };
  # wayland.windowManager.hyprland.catppuccin = {
  #   enable = true;
  #   flavor = flavor;
  #   accent = accent;
  # };
}
