-- snacks.nvim: 便利機能の詰め合わせ
-- https://github.com/folke/snacks.nvim
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    notifier = { enabled = true },
    terminal = { enabled = true },
    scratch = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    scroll = { enabled = true },
    dashboard = { enabled = true },
    picker = { enabled = true },
  },
  keys = {
    -- Explorer
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- Scratch
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- Terminal
    { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    -- Picker
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    -- Notifier
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
  },
}
