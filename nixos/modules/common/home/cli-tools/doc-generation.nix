{
  programs = {
    pandoc = { enable = true; };
    texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs)
          scheme-basic enumitem mmap cmap titlesec metafont xcolor soul setspace
          substr xstring xifthen ifmtarg lastpage biblatex biblatex-ext helvetic
          csquotes europasscv latexindent;
      };
    };
  };
}
