{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  users.users.yoshikouki = {
    home = "/Users/yoshikouki";
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.yoshikouki = import ./home.nix;
  };

  system.stateVersion = 5;
}
