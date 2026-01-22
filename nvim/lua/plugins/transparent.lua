-- 背景を透過にする設定
return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      extra_groups = {
        -- 基本的なフローティングウィンドウ
        "NormalFloat", -- フローティングウィンドウ本体
        "FloatBorder", -- フローティングウィンドウのボーダー

        -- ファイルツリー
        "NvimTreeNormal", -- nvim-tree
        "NeoTreeNormal", -- neo-tree
        "NeoTreeNormalNC", -- neo-tree（非アクティブ）

        -- ポップアップ
        "WhichKeyFloat", -- which-key

        -- ウィンドウ区切り線
        "WinSeparator", -- ウィンドウの区切り線
        "VertSplit", -- 垂直分割線（古いバージョン互換用）

        -- ステータスライン
        "StatusLine", -- アクティブなステータスライン
        "StatusLineNC", -- 非アクティブなステータスライン

        -- タブライン/バッファライン
        "TabLine", -- タブライン
        "TabLineFill", -- タブラインの背景
        "TabLineSel", -- 選択中のタブ
        "BufferLineBackground", -- bufferline の背景
        "BufferLineFill", -- bufferline の塗りつぶし領域

        -- その他の UI 要素
        "SignColumn", -- サインカラム（gitsigns、診断アイコンなど）
        "EndOfBuffer", -- バッファ終端の ~ 記号
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
