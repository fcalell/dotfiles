{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession = {
      enable = true;
      args = [ "-w 2560" "-h 1440" "-r 144" "--hdr-enabled" "--adaptive-sync" ];
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = [ "-w 2560" "-h 1440" "-r 144" "--hdr-enabled" "--adaptive-sync" ];
  };
  # https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
  # environment.systemPackages = with pkgs; [ steamtinkerlaunch ];
}
