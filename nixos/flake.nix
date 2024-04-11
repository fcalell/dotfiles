{
  description = "NixOS configuration";

  nixConfig = {
    extra-trusted-public-keys =
      # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    extra-substituters = "https://nix-community.cachix.org";
    # "https://devenv.cachix.org";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    hyprland.url = "github:hyprwm/hyprland";
    # devenv.url = "github:cachix/devenv";
  };

  outputs = { nixpkgs, nix-darwin, ... }@inputs: {
    nixosConfigurations = {
      main_pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
        };
        modules = [
          ./modules/nixos/core/deafult.nix
          ./hosts/main_pc/hardware-configuration.nix
        ];
      };
    };
    darwinConfigurations = {
      macbook = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          system = "x86_64-darwin";
        };
        modules = [ ./modules/macbook/core/default.nix ];
      };
    };
  };
}
