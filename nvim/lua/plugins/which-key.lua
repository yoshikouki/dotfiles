-- which-key.nvim: キーマップを表示するポップアップ
-- https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    delay = 200,
    spec = {
      { "<leader>f", group = "file" },
      { "<leader>b", group = "buffer" },
      { "<leader>g", group = "git" },
      { "<leader>s", group = "search" },
      { "<leader>w", proxy = "<c-w>", group = "windows" },
    },
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
