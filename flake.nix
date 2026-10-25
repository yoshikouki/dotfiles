{
  description = "Personal macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lix.url = "git+https://git.lix.systems/lix-project/lix?ref=2.96.0&shallow=1";
    lix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, home-manager, lix, ... }: {
    packages.aarch64-darwin.lix =
      (self.darwinConfigurations.mbp.pkgs.extend lix.overlays.default).nix;

    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      modules = [
        ./nix/darwin.nix
        home-manager.darwinModules.home-manager
        {
          networking = {
            computerName = "mbp";
            hostName = "mbp";
            localHostName = "mbp";
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yoshikouki = import ./nix/home;
        }
      ];
    };
  };
}
