{ pkgs, ... }:
let
  xcodeBuildServer = pkgs.callPackage ../packages/xcode-build-server.nix { };
  # The pinned release channel still has 8.22.0. Remove this override once it catches up.
  curl = pkgs.curl.overrideAttrs (finalAttrs: _: {
    version = "8.23.0";
    src = pkgs.fetchurl {
      url = "https://curl.se/download/curl-${finalAttrs.version}.tar.xz";
      sha256 = "8dadd7d2536a314f982ad05a651b713f426bf7d02cc2c76cffb9796f2218e6c5";
    };
  });
in
{
  home.packages = with pkgs; [
    gh ghq jq tree coreutils
    direnv bat eza fd fzf ripgrep zoxide
    delta difftastic lazygit neovim tree-sitter tmux yazi
    mise
    # Install DB tools without creating databases or enabling background services.
    mysql84 postgresql_17
    # Xcode itself remains installed and updated through Apple's tools.
    mas xcodegen xcbeautify swiftformat swiftlint ios-deploy fastlane cocoapods
    xcodeBuildServer
    curl
  ];
}
