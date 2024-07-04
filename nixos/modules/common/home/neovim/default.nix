{ inputs, pkgs, config, ... }:

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
  xdg.configFile."nvim/lua" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/common/home/neovim/lua";
  };
}
