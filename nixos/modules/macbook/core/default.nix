{ inputs, pkgs, username, ... }: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system = {
    stateVersion = 4;
    defaults = {
      LaunchServices = { LSQuarantine = false; };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = false;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = { _FXShowPosixPathInTitle = false; };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };

  nix.configureBuildUsers = true;
  nix.settings.trusted-users = [ "root" "fcalell" ];

  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh.enable = true;
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  #Home manager
  imports = [ inputs.home-manager.darwinModules.home-manager ];
  home-manager = {
    # useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/Users/${username}";
      home.stateVersion = "24.11";
      imports = [ ../../common/home/default.nix ../home/default.nix ];
      programs.home-manager.enable = true;
    };
  };
}
