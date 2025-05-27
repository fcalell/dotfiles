{ pkgs, ... }: {
  imports = [
    ./aerospace
    #./jankyborders.nix 
  ];
  home.packages = with pkgs; [ gnused nicotine-plus cocoapods ];
}
