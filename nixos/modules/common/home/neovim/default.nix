{ pkgs, ... }:

{
  imports = [ ./lsp ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = pkgs.neovim-nightly;
  };
}
