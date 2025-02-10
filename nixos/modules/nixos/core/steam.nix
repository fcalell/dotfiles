{ pkgs, ... }:
let
  steamos = pkgs.pkgs.writeShellScriptBin "steamos" ''
    set -xeuo pipefail
    gamescope --steam --rt --adaptive-sync -- steam -tenfoot -steamos3 -pipewire-dmabuf
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
    gamescopeSession = {
      enable = true;
      args = [ "--rt" "--adaptive-sync" ];
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  environment.systemPackages = [ steamos steamos-session-select ];
  # https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
  # environment.systemPackages = with pkgs; [ steamtinkerlaunch ];
}
