{ pkgs, ... }:
let
  steamos = pkgs.pkgs.writeShellScriptBin "steamos" ''
    set -xeuo pipefail
    gamescope --steam --adaptive-sync --hdr-enabled -- steam -tenfoot -steamos3
  '';

  steamos-session-select =
    pkgs.pkgs.writeShellScriptBin "steamos-session-select" ''
      steam -shutdown
    '';
in {
  programs.steam = {
    enable = true;
    # protontricks.enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
    # extest.enable = true;
    # protontricks.enable = true;
    gamescopeSession = {
      enable = true;
      args = [
        "--adaptive-sync"
        "--hdr-enabled"
        "--mangoapp"
        "-W 2560"
        "-H 1440"
        # "-R"
      ];
      steamArgs = [ "-tenfoot" "-steamos3" ];
      # env = { WAYLAND_DISPLAY = "wayland-1"; };
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages =
    [ steamos steamos-session-select pkgs.bottles pkgs.mangohud ];
  # https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
  # environment.systemPackages = with pkgs; [ steamtinkerlaunch ];
}
