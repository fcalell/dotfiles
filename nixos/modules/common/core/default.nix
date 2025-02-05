{ inputs, ... }: {
  nix = {
    optimise.automatic = true;
    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };
  nixpkgs.overlays = [ inputs.android-nixpkgs.overlays.default ];
  nixpkgs.config.allowUnfree = true;
}
