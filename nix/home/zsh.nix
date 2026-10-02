{ config, lib, pkgs, ... }:
let
  plugins = pkgs.symlinkJoin {
    name = "dotfiles-zsh-plugins";
    paths = with pkgs; [
      zsh-completions zsh-autosuggestions
      zsh-history-substring-search zsh-syntax-highlighting
    ];
  };
  legacy = lib.readFile ../../.zshrc;
  nixShell = lib.replaceStrings
    [
      "if command -v brew &> /dev/null; then\n  HOMEBREW_PREFIX=\"$(brew --prefix)\"\nfi"
      "HOMEBREW_PREFIX"
      "alias pkg-update='brew update && brew upgrade && mise self-update --yes --no-plugins && mise upgrade'"
      "export PIPX_DEFAULT_PYTHON=\"$(mise where python)/bin/python3\""
    ]
    [
      ''DOTFILES_ZSH_PREFIX="${plugins}"''
      "DOTFILES_ZSH_PREFIX"
      ''
function pkg-update() {
  local repo="''${DOTFILES_REPO_DIR:-$HOME/src/github.com/yoshikouki/dotfiles}"
  nix flake update "path:$repo" &&
    sudo darwin-rebuild switch --flake "path:$repo#K2-MacBook-Pro"
}
''
      ''
if mise_python=$(mise where python 2>/dev/null); then
      export PIPX_DEFAULT_PYTHON="$mise_python/bin/python3"
    fi
''
    ] legacy;
  session = ''
    # Keep CLI discovery reliable even when an app passes inherited shell guards.
    path=("${config.home.profileDirectory}/bin" /run/current-system/sw/bin /nix/var/nix/profiles/default/bin $path)
    export PATH
    if [ -f "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh" ]; then
      source "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
    fi
  '';
in
{
  # Retain existing functions and bindings while supplying plugin paths through Nix.
  # No programs.zsh module here: it would also generate these same files.
  home.file = {
    ".zshrc".text = nixShell;
    ".zshenv".text = session + lib.readFile ../../.zshenv;
    ".zprofile".text = session + lib.readFile ../../.zprofile;
    ".zlogin".source = ../../.zlogin;
    ".zlogout".source = ../../.zlogout;
  };
}
