return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      -- ファイル名の最大長を増やす（デフォルト: 18）
      max_name_length = 30,

      -- タブの最小幅を設定
      tab_size = 20,

      -- セパレーターのスタイル
      separator_style = "thin",

      -- 閉じるアイコンを非表示（スペース確保）
      show_buffer_close_icons = false,

      -- 名前の切り詰めを無効化
      truncate_names = false,
    },
  },
}
