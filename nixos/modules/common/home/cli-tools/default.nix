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
    gcc13
    nodejs_20
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
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
