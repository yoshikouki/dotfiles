{ config, pkgs, ... }:
{
  home.username = "yoshikouki";
  home.homeDirectory = "/Users/yoshikouki";
  home.stateVersion = "24.11";

  programs.fish.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

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
  ];

  home.file.".config/fish/config.fish".source = ../config.fish;

  home.file.".config/nvim" = {
    source = ../nvim;
    recursive = true;
  };

  home.file.".local/bin" = {
    source = ../local-bin;
    recursive = true;
  };
}
