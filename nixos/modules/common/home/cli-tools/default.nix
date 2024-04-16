{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    duf
    du-dust
    tre-command
    neofetch
    gnumake
    fd
    unzip
    fzf
    fd
    lazygit
    (hiPrio gcc)
    clang
    nodejs_20
    nodejs_20.pkgs.pnpm
    nodejs_20.pkgs.yarn
    tree-sitter
    luajit
    # pkgs.yarn
    # pkgs.nodePackages.pnpm
    # pkgs.python3
  ];
  programs = {
    ripgrep.enable = true;
    fzf.enable = true;
    lf = {
      enable = true;
      settings = { hidden = true; };
    };
    git = {
      enable = true;
      userName = "fcalell";
      userEmail = "frankie.calella@gmail.com";
    };
    # direnv = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   nix-direnv.enable = true;
    # };
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
