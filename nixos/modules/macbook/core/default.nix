{inputs,...}:
let 
  username = "fcalell";
in
{
	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

	# The platform the configuration will be used on.
	nixpkgs.hostPlatform = "x86_64-darwin";
	nix.configureBuildUsers = true;
	security.pam.enableSudoTouchIdAuth = true;
	users.users.${username} = {
		name = "${username}";
		home = "/Users/${username}";
	};

	#Home manager
	imports = [inputs.home-manager.darwinModules.home-manager];
	home-manager = {
	    # useUserPackages = true;
	    useGlobalPkgs = true;
	    extraSpecialArgs = { inherit inputs username; };
	    users.${username} = {
	      home.username = "${username}";
	      home.homeDirectory = "/Users/${username}";
	      home.stateVersion = "23.11";
	      imports = [ ../../common/home/default.nix ];
	      programs.home-manager.enable = true;
    };
  };
}
