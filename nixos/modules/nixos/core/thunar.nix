{ pkgs, ... }: {
  services.gvfs = { enable = true; };
  security.polkit.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
}
