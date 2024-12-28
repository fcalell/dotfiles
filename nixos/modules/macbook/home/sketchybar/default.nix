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
  home.packages = with pkgs; [ sketchybar ];

  launchd.user.agents.sketchybar = {
    serviceConfig.ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" ];
    serviceConfig.KeepAlive = true;
    serviceConfig.RunAtLoad = true;
  };

  xdg.configFile."sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/macbook/home/sketchybar/config";
  };
  xdg.dataFile."sketchybar_lua" = { source = "${sbarlua}"; };
}
