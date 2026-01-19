# Neovim Configuration

## ディレクトリ構造

```
nvim/
├── init.lua              # エントリポイント（require のみ）
└── lua/
    ├── core/             # 基本設定（プラグイン非依存）
    │   ├── options.lua   # vim.opt 設定
    │   ├── keymaps.lua   # 基本キーマップ
    │   └── autocmds.lua  # オートコマンド・ユーザーコマンド
    ├── config/           # プラグインマネージャー設定
    │   └── lazy.lua      # lazy.nvim ブートストラップ
    └── plugins/          # プラグイン specs（1プラグイン = 1ファイル）
        └── *.lua
```

## 設計原則

- **1ファイル1責務**: options/keymaps/autocmds を明確に分離
- **core/ はプラグイン非依存**: プラグインなしでも動作する基本設定
- **プラグイン固有のキーマップは各 spec 内に定義**: `keys = { ... }` で lazy loading と連携

## プラグインファイル規約

各プラグインファイルの先頭にプラグインの概要とURLをコメントで記述する:

```lua
-- telescope.nvim: ファジーファインダー
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  },
  opts = {},
}
```

## プラグイン追加手順

1. `lua/plugins/` に新規ファイル作成（例: `telescope.lua`）
2. ファイル先頭にプラグイン概要とURLをコメント
3. lazy.nvim spec を記述（keys, opts など）
4. lazy.nvim が `{ import = "plugins" }` で自動読み込み

## グローバル設定

`init.lua` に記述する設定（lazy.nvim 読み込み前に必要）:

```lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
```

## ファイル別責務

| ファイル | 内容 |
|---------|------|
| `init.lua` | エントリポイント、グローバル設定（mapleader など） |
| `core/options.lua` | vim.opt 設定（表示、インデント、クリップボードなど） |
| `core/keymaps.lua` | 基本キーマップ（プラグイン非依存） |
| `core/autocmds.lua` | autocmd、user command |
| `config/lazy.lua` | lazy.nvim ブートストラップ |
| `plugins/*.lua` | 個別プラグイン設定 |
