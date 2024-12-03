{ username, inputs, ... }: {
  nixpkgs.overlays = [ inputs.android-nixpkgs.overlays.default ];
  programs.adb.enable = true;
  users.users.${username}.extraGroups = [ "adbusers" ];
}
