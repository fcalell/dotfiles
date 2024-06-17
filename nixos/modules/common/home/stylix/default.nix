{ inputs, pkgs }: {
  imports = [ inputs.stylix.homeManagerModules.stylix ];
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    fonts = {
      packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        pkgs.noto-fonts
        pkgs.noto-fonts-emoji
      ];
      serif = { name = "Noto Serif"; };
      sansSerif = { name = "Noto Sans"; };
      monospace = { name = "JetBrainsMono Nerd Font"; };
      emoji = { name = "Noto Color Emoji"; };
    };
    image = "~/nixos/assets/wallpapers/feet-on-the-dashboard.png";
    opacity = { terminal = 0.98; };
  };
}
