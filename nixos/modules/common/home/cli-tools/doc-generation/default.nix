{ pkgs, ... }: {
  programs = {
    pandoc = { enable = true; };
    texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs)
          scheme-basic
          # Fonts and encoding
          fontspec xunicode unicode-math upquote sourcesanspro ly1 titling
          # Language + quotes
          babel csquotes polyglossia
          # Layout
          geometry footmisc setspace parskip microtype titlesec fancyvrb
          footnotebackref zref needspace
          # Math
          amsmath
          # Code listings
          listings fvextra sourcecodepro
          # Tables
          booktabs multirow
          # Graphics
          float xcolor adjustbox
          # Blockquotes
          mdframed
          # Links
          hyperref xurl bookmark
          # Misc support
          iftex soul etoolbox koma-script caption
          # Optional but helpful
          eurosym;
      };
    };
  };

  home.packages = with pkgs;
    [ (writeShellScriptBin "md2pdf" (builtins.readFile ./md2pdf.sh)) ];

  home.file.".config/pandoc/templates/eisvogel.latex".source =
    ./templates/eisvogel.latex;
}
