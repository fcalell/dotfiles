{ pkgs, ... }:

{
  home.packages = [
    # Formatters
    pkgs.stylua
    pkgs.nixfmt
    pkgs.perl538Packages.LatexIndent
    pkgs.biome
    # LSP
    pkgs.nil
    pkgs.lua-language-server
  ];
}
