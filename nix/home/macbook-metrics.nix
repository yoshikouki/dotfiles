{ config, lib, pkgs, ... }:
let
  metricsDirectory = "${config.home.homeDirectory}/.local/state/macbook-metrics";
in
{
  home.packages = [ pkgs.telegraf ];
  launchd.agents.macbook-metrics = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.telegraf}/bin/telegraf"
        "--config"
        "${config.home.homeDirectory}/.config/macbook-metrics/telegraf.conf"
      ];
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
