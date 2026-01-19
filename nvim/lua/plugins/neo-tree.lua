return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- 隠しファイルと gitignore ファイルを表示
        hide_dotfiles = false, -- ドットファイルを表示
        hide_gitignored = false, -- gitignore されたファイルを表示
        hide_hidden = false, -- OS の隠しファイルを表示 (Windows)
      },
    },
  },
}
