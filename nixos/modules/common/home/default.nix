{ pkgs, ... }:

{
  imports = [ ./terminal ./zsh ./neovim ./tools ./fonts ./env ];
  programs = {
    git = {
      enable = true;
      userName = "fcalell";
      userEmail = "frankie.calella@gmail.com";
    };
  };
  home.packages = [
    pkgs.yarn
    pkgs.nodejs_20
    pkgs.google-chrome
    pkgs.gcc_multi
    pkgs.gnumake
    pkgs.python3
    pkgs.unzip
    pkgs.fzf
    pkgs.ripgrep
  ];
}
