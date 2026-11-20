{ pkgs, ... }:
let
  # Pinned release binaries for host metrics; yoshikouki/agent runs the collector.
  telegraf = pkgs.callPackage ../packages/telegraf.nix { };
  macmon = pkgs.callPackage ../packages/macmon.nix { };
in
{
  imports = [ ./macos-shortcuts.nix ];
  home.packages = [ telegraf macmon ] ++ (with pkgs; [
    # Installing DB tools does not enable database services.
    mysql84 postgresql_17
    # Xcode itself is managed by Apple's tools.
    mas xcodegen xcbeautify swiftformat swiftlint ios-deploy fastlane cocoapods
    (pkgs.callPackage ../packages/xcode-build-server.nix { })
  ]);
}
