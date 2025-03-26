{ inputs, pkgs, username, ... }: {
  # Auto upgrade nix package and the daemon service.
  nix.enable = false;
  nix.package = pkgs.nix;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system = {
    stateVersion = 4;
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        launchanim = false;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
      };
      finder = { _FXShowPosixPathInTitle = false; };
    };
  };

  nix.settings.trusted-users = [ "root" "fcalell" ];
  ids.gids.nixbld = 350;
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/Users/${username}";
      home.stateVersion = "24.11";
      imports = [
        ../../common/home/default.nix
        ../home/default.nix
        inputs.mac-app-util.homeManagerModules.default
      ];
      programs.home-manager.enable = true;
    };
  };
}
