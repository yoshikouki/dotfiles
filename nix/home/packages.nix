{ pkgs, ... }:
{
  # Common interactive tools. Databases and platform-specific build tools follow later.
  home.packages = with pkgs; [
    gh ghq jq tree coreutils
    direnv bat eza fd fzf ripgrep zoxide
    delta difftastic lazygit neovim tree-sitter tmux yazi
    mise
  ];
}
