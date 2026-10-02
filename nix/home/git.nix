{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "yoshikouki";
        email = "yoshikouki@gmail.com";
        id = "yoshikouki";
      };
      ghq.root = "~/src";
      core = {
        excludesfile = "~/.gitignore_global";
        pager = "delta";
        editor = "nvim";
      };
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        dark = true;
        line-numbers = true;
        side-by-side = false;
      };
      init.defaultBranch = "main";
      alias = {
        dft = "-c diff.external=difft diff";
        dshow = "-c diff.external=difft show --ext-diff";
        dlog = "-c diff.external=difft log -p --ext-diff";
      };
      difftool.difftastic.cmd = ''difft "$LOCAL" "$REMOTE"'';
      credential."https://github.com".helper = [ "" "!gh auth git-credential" ];
      credential."https://gist.github.com".helper = [ "" "!gh auth git-credential" ];
    };
    # Home Manager writes includes after common settings so local overrides win.
    includes = [ { path = "~/.config/git/local.gitconfig"; } ];
  };
}
