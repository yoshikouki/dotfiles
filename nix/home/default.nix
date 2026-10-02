{ config, lib, pkgs, ... }:
let
  scripts = builtins.readDir ../../local-bin;
  miseDirectory = "${config.home.homeDirectory}/src/github.com/yoshikouki/dotfiles/mise";
in
{
  imports = [ ./packages.nix ./git.nix ./zsh.nix ./macos-shortcuts.nix ];
  home.stateVersion = "26.05";
  xdg.enable = true;

  home.file = {
    ".vimrc".source = ../../.vimrc;
    ".gitignore_global".source = ../../.gitignore_global;
  } // lib.mapAttrs' (name: _: lib.nameValuePair ".local/bin/${name}" {
    source = ../../local-bin + "/${name}";
    executable = true;
  }) (lib.filterAttrs (_: kind: kind == "regular") scripts);

  xdg.configFile = {
    "mise/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${miseDirectory}/config.toml";
    "mise/mise.lock".source = config.lib.file.mkOutOfStoreSymlink "${miseDirectory}/mise.lock";
  };

  # This editable, machine-specific include must never enter the Nix store.
  home.activation.gitLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    localConfig="$HOME/.config/git/local.gitconfig"
    if [ ! -e "$localConfig" ]; then
      run mkdir -p "$HOME/.config/git"
      run cp ${../../.gitconfig.macos} "$localConfig"
      run chmod 600 "$localConfig"
    fi
  '';
}
