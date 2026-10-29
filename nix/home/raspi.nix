{ config, ... }:
{
  imports = [ ./default.nix ];
  home.username = "yoshikouki";
  home.homeDirectory = "/home/${config.home.username}";
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
