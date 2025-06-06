{ inputs, pkgs, ... }:
let code-cursor = pkgs.callPackage ./code-cursor/default.nix { };
in {
  nixpkgs.overlays = [ inputs.android-nixpkgs.overlays.default ];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [ code-cursor ];
}
