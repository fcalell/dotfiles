{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix";
    # devenv.url = "github:cachix/devenv";
  };

  outputs = { nixpkgs, nix-darwin, ... }@inputs:
    let username = "fcalell";
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [
            ./modules/common/core/default.nix
            ./modules/nixos/core/deafult.nix
            ./hosts/main_pc/hardware-configuration.nix
          ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [
            ./modules/wsl/core/default.nix
            ./modules/common/core/default.nix
          ];
        };
      };
      darwinConfigurations = {
        macbook = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs username; };
          modules = [
            ./modules/common/core/default.nix
            ./modules/macbook/core/default.nix
          ];
        };
      };
    };
}
