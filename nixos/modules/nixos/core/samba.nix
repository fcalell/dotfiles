{ pkgs, ... }:
{
  # environment.systemPackages = [ pkgs.cifs-utils ];
  # services.samba = {
  #   enable = true;
  #   # You will still need to set up the user accounts to begin with:
  #   # $ sudo smbpasswd -a yourusername
  #   securityType = "user";
  #   openFirewall = true;
  #   extraConfig = ''
  #     workgroup = WORKGROUP 
  #     server string = smbnix
  #     netbios name = smbnix
  #     security = user 
  #     #use sendfile = yes
  #     #max protocol = smb2
  #     # note: localhost is the ipv6 localhost ::1
  #     hosts allow = 192.168.0. 127.0.0.1 localhost
  #     hosts deny = 0.0.0.0/0
  #     guest account = nobody
  #     map to guest = bad user
  #   '';
  #   shares = {
  #     public = {
  #       path = "/home/fcalell/Music";
  #       browseable = "yes";
  #       writable = "yes";
  #       "guest ok" = "yes";
  #       "read only" = "no";
  #       "create mask" = "0644";
  #       "directory mask" = "0755";
  #     };
  #   };
  # };
  # services.samba-wsdd = {
  #   enable = true;
  #   openFirewall = true;
  # };
  #
  # networking.firewall.enable = true;
  # networking.firewall.allowPing = true;
}
