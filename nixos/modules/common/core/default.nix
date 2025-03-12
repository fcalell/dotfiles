{ inputs, ... }: {
  nixpkgs.overlays = [ inputs.android-nixpkgs.overlays.default ];
  nixpkgs.config.allowUnfree = true;
}
