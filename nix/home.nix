{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  username = "yoshikouki";
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.11";

  # zsh configuration is managed via dotfiles/.zshrc symlink
  # zoxide is initialized in .zshrc manually
  # nvim and local-bin are symlinked by install scripts

  home.packages = with pkgs; [
    fd
    fzf
    ghq
    ripgrep
    jq
    bat
    delta
    eza
    git
    go
    nodejs
    ruby
    python3
    bun
    rustup
    lazygit
    tmux
    yazi
    zoxide
    neovim
    gh
    tree-sitter
  ];

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
}
