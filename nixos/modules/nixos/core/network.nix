{ pkgs, ... }: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # nameservers = [ "8.8.8.8" ];
    # firewall = {
    # enable = true;
    # allowedTCPPorts = [ 22 80 443 59010 59011 7777 ];
    # allowedUDPPorts = [ 59010 59011 7777 ];
    # allowedUDPPortRanges = [
    # { from = 4000; to = 4007; }
    # { from = 8000; to = 8010; }
    # ];
    # };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
