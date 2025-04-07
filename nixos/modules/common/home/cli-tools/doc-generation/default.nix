{ pkgs, ... }: {
  programs = {
    pandoc = { enable = true; };
    texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs)
          scheme-basic enumitem mmap cmap titlesec metafont xcolor soul setspace
          substr xstring xifthen ifmtarg lastpage biblatex biblatex-ext helvetic
          csquotes latexindent;
      };
    };
  };

  home.packages = with pkgs;
    [ (writeShellScriptBin "md2pdf" (builtins.readFile ./md2pdf.sh)) ];

  home.file.".config/pandoc/templates/eisvogel.latex".source =
    ./templates/eisvogel.latex;
}
