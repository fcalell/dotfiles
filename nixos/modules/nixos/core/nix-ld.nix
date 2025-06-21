{ inputs, pkgs, ... }: {
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];
  services.envfs.enable = true;
  environment.stub-ld.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = (with pkgs; [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    nss
    nspr
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxkbfile
    pango
    pciutils
    stdenv.cc.cc.lib
    systemd
    libdrm
    mesa
    libxkbcommon
    libGL
    vulkan-loader
    wrapGAppsHook3
  ]);
}
