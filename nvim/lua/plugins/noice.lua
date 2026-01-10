-- noice.nvim: メッセージ、コマンドライン、ポップアップメニューのUI改善
-- https://github.com/folke/noice.nvim
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      progress = {
        enabled = true,
        view = "mini",
      },
      hover = {
        enabled = true,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          throttle = 50,
        },
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
  keys = {
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end,
      mode = { "n", "i", "s" },
      silent = true,
      expr = true,
      desc = "Scroll forward (LSP docs)",
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end,
      mode = { "n", "i", "s" },
      silent = true,
      expr = true,
      desc = "Scroll backward (LSP docs)",
    },
  },
}
