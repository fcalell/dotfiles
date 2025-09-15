{ inputs, ... }:
# let code-cursor = pkgs.callPackage ./code-cursor/default.nix { };
# in 
# environment.systemPackages = [ code-cursor ];
{
  nixpkgs.overlays = [ inputs.android-nixpkgs.overlays.default ];
  nixpkgs.config.allowUnfree = true;
}
