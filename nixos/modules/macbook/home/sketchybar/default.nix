{ pkgs, config, ... }:
let
  sbarlua = pkgs.stdenv.mkDerivation {
    pname = "sketchybar-lua";
    version = "0.1";
    src = pkgs.fetchFromGitHub {
      owner = "FelixKratz";
      repo = "SbarLua";
      rev = "main";
      sha256 = "F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
    };
    nativeBuildInputs = with pkgs; [ clang gcc ];
    buildInputs = with pkgs; [ readline ];
    installPhase = ''
      mv bin "$out"
    '';
  };
in {
  home.packages = [ sbarlua ];
  services.sketchybar.enable = true;

  xdg.configFile."sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/sketchybar/config";
  };
  home.file.".local/share/sketchybar_lua" = { source = "${sbarlua}"; };
}
