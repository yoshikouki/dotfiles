{ config, ... }:
{
  imports = [ ./default.nix ];
  home.username = "yoshikouki";
  home.homeDirectory = "/home/${config.home.username}";
  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = false;
  programs.home-manager.enable = true;
}
