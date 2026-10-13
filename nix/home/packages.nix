{ pkgs, ... }:
let
  xcodeBuildServer = pkgs.callPackage ../packages/xcode-build-server.nix { };
in
{
  home.packages = with pkgs; [
    curl gh ghq jq tree coreutils
    direnv bat eza fd fzf ripgrep zoxide
    delta difftastic lazygit neovim tree-sitter tmux yazi
    mise
    # Install DB tools without creating databases or enabling background services.
    mysql84 postgresql_17
    # Xcode itself remains installed and updated through Apple's tools.
    mas xcbeautify swiftformat swiftlint ios-deploy fastlane cocoapods
    xcodeBuildServer
  ];
}
