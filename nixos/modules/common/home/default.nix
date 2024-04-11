{ inputs, ... }:

{
  imports = [
    ./terminal
    # ./browser
    ./zsh
    ./neovim
    ./cli-tools
    ./fonts
    ./env
    # ./android 
  ];
  nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ];
}
