{ pkgs, inputs, ... }:

{
  imports = [ ./lsp ];
  nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = pkgs.neovim-nightly;
  };
}
