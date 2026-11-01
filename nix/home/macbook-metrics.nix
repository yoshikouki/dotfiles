{ config, lib, pkgs, ... }:
let
  telegraf = pkgs.callPackage ../packages/telegraf.nix { };
  macmon = pkgs.callPackage ../packages/macmon.nix { };
  metricsDirectory = "${config.home.homeDirectory}/.local/state/macbook-metrics";
in
{
  home.packages = [ telegraf macmon ];
  launchd.agents.macbook-metrics = {
    enable = true;
    config = {
      ProgramArguments = [
        "${telegraf}/bin/telegraf"
        "--config"
        "${config.home.homeDirectory}/.config/macbook-metrics/telegraf.conf"
      ];
      EnvironmentVariables.MACMON = "${macmon}/bin/macmon";
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "${metricsDirectory}/stdout.log";
      StandardErrorPath = "${metricsDirectory}/stderr.log";
      ProcessType = "Background";
    };
  };
  home.activation.macbookMetricsDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p ${metricsDirectory}
  '';
}
