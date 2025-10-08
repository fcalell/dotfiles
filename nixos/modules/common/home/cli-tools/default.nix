{ pkgs, ... }:

{
  imports = [ ./doc-generation ];
  home.packages = with pkgs; [
    chafa
    duf
    du-dust
    tre-command
    neofetch
    openssl
    gnumake
    unar
    (hiPrio gcc)
    clang
    readline
    nodejs_24
    yarn-berry
    pnpm
    bun
    python3
    uv
    claude-code
    # tree-sitter
    lua5_4_compat
    # pkgs.yarn
    # pkgs.nodePackages.pnpm
    # pkgs.python3
  ];
  xdg = { enable = true; };
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
    lazygit.settings = { disableStartupPopups = false; };
    lf = {
      enable = true;
      settings = { hidden = true; };
    };
    ripgrep.enable = true;
  };
}
