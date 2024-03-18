{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Formatters
    stylua
    nixfmt
    perl538Packages.LatexIndent
    biome
    # LSP
    nil
    lua-language-server
    nodePackages_latest.typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
  ];
}
