{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  users.users.yoshikouki = {
    home = "/Users/yoshikouki";
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.yoshikouki = import ./home.nix;
  };

  system.stateVersion = 5;
}
