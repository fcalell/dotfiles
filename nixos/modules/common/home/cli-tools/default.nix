{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    lf
    duf
    du-dust
    tre-command
    neofetch
    gnumake
    unzip
    fzf
    fd
    ripgrep
    lazygit
    gcc_multi
    # pkgs.nodejs_20
    # pkgs.yarn
    # pkgs.nodePackages.pnpm
    # pkgs.python3
  ];
  programs = {
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
