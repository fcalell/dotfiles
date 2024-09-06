{ inputs, pkgs, ... }: {
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = (with pkgs; [
    electron
    glib
    nss_latest
    nspr
    dbus
    at-spi2-atk
    cups
    libdrm
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    mesa
    expat
    libxkbcommon
    alsa-lib
  ]);
}
