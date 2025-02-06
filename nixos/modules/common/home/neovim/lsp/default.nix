{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Formatters
    stylua
    nixfmt-classic
    biome
    prettierd
    # LSP
    tree-sitter
    texlab
    nil
    lua-language-server
    typescript-language-server
    vtsls
    vscode-langservers-extracted
    tailwindcss-language-server
    astro-language-server
    bash-language-server
  ];
}
