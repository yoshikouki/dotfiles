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
      mkHomeConfig = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./nix/home.nix
        ];
      };
    in
    {
      # macOS (nix-darwin)
      darwinConfigurations.mac = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
        ];
      };

      # Linux (home-manager standalone)
      homeConfigurations = {
        "yoshikouki@aarch64-linux" = mkHomeConfig "aarch64-linux";
        "yoshikouki@x86_64-linux" = mkHomeConfig "x86_64-linux";
      };
    };
}
