{
  description = "yoshikouki dotfiles (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";
    in {
      darwinConfigurations.mac = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
        ];
      };
    };
}
