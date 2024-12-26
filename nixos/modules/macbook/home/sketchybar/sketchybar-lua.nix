{ pkgs, lib }:
pkgs.stdenv.mkDerivation {
  pname = "sketchybar-lua";
  version = "0.1";
  src = pkgs.fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "main";
    sha256 = lib.fakeSha256; # This will fail and show the correct hash
  };
  nativeBuildInputs = with pkgs; [ clang gcc ];
  buildInputs = with pkgs; [ readline ];
  installPhase = ''
    mv bin "$out"
  '';
}
