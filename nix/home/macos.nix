{ pkgs, ... }:
{
  imports = [ ./macos-shortcuts.nix ];
  home.packages = with pkgs; [
    # Installing DB tools does not enable database services.
    mysql84 postgresql_17
    # Xcode itself is managed by Apple's tools.
    mas xcodegen xcbeautify swiftformat swiftlint ios-deploy fastlane cocoapods
    (pkgs.callPackage ../packages/xcode-build-server.nix { })
  ];
}
