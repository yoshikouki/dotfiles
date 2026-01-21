-- 背景を透過にする設定
return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      extra_groups = {
        "NormalFloat", -- フローティングウィンドウ
        "NvimTreeNormal", -- nvim-tree
        "NeoTreeNormal", -- neo-tree
        "NeoTreeNormalNC",
        "WhichKeyFloat", -- which-key
      },
      exclude_groups = {},
    },
    config = function(_, opts)
      require("transparent").setup(opts)
      -- プラグイン読み込み後に透過を有効化
      vim.cmd("TransparentEnable")
    end,
  },
}
