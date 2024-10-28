{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Formatters
    stylua
    nixfmt-classic
    biome
    prettierd
    # LSP
    texlab
    nil
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    bash-language-server
  ];
}
