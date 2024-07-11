{ pkgs, ... }:

{
  home.packages = with pkgs; [
    duf
    du-dust
    tre-command
    neofetch
    gnumake
    unzip
    (hiPrio gcc)
    clang
    nodejs_20
    nodejs_20.pkgs.pnpm
    nodejs_20.pkgs.yarn
    bun
    python3
    tree-sitter
    luajit
    # pkgs.yarn
    # pkgs.nodePackages.pnpm
    # pkgs.python3
  ];
  programs = {
    btop = {
      enable = true;
      settings = { vim_keys = "true"; };
    };
    fd = {
      enable = true;
      hidden = true;
    };
    fzf.enable = true;
    git = {
      enable = true;
      userName = "fcalell";
      userEmail = "frankie.calella@gmail.com";
    };
    lazygit.enable = true;
    lf = {
      enable = true;
      settings = { hidden = true; };
    };
    ripgrep.enable = true;
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
