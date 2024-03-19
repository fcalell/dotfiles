{ pkgs, ... }:

{
  home.packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.btop
    pkgs.lf
    pkgs.lazygit
    pkgs.duf
    pkgs.du-dust
    pkgs.tre-command
    pkgs.neofetch
    pkgs.gcc_multi
    pkgs.gnumake
    pkgs.python3
    pkgs.unzip
    pkgs.fzf
    pkgs.ripgrep
  ];
  programs = {
    git = {
      enable = true;
      userName = "fcalell";
      userEmail = "frankie.calella@gmail.com";
    };
  };
}
