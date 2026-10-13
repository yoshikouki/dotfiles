{ config, lib, pkgs, ... }:
let
  plugins = pkgs.symlinkJoin {
    name = "dotfiles-zsh-plugins";
    paths = with pkgs; [
      zsh-completions zsh-autosuggestions
      zsh-history-substring-search zsh-syntax-highlighting
    ];
  };
  nixShell = ''
    DOTFILES_ZSH_PREFIX="${plugins}"
  '' + lib.readFile ../../.zshrc;
  session = ''
    export DOTFILES_PACKAGE_MANAGER=nix
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
