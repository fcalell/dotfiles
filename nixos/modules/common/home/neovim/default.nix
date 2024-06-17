{ inputs, pkgs, ... }:

{
  imports = [ ./lsp ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraLuaConfig = ''
          	require('config')
      	'';
  };
  home.file.".config/nvim/lua" = {
    source = ./lua;
  };
}
