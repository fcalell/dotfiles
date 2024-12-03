{
  imports = [ ./adb.nix ];
  nix = {
    optimise.automatic = true;
    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };
  nixpkgs.config.allowUnfree = true;
}
