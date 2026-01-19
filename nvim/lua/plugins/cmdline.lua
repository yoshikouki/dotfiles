-- コマンドライン補完の設定
return {
  -- cmp-cmdline の強化
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",
      "petertriho/cmp-git",
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      -- 補完ウィンドウのスタイル
      local window_style = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }

      -- `/` 検索コマンドの補完
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
        window = { completion = window_style },
      })

      -- `?` 逆検索コマンドの補完
      cmp.setup.cmdline("?", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
        window = { completion = window_style },
      })

      -- `:` コマンドの補完
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
        window = { completion = window_style },
      })
    end,
  },

  -- cmp-git の設定
  {
    "petertriho/cmp-git",
    opts = {},
  },

  -- noice.nvim のcmdline設定
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline_popup",
        format = {
          cmdline = { icon = ">" },
          search_down = { icon = "/" },
          search_up = { icon = "?" },
          filter = { icon = "$" },
          lua = { icon = "" },
          help = { icon = "?" },
        },
      },
      presets = {
        command_palette = true,
      },
    },
  },
}
