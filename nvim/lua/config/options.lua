-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- VSCode風の設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 外観設定
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", extends = "…", precedes = "…", nbsp = "␣" }
vim.opt.fillchars = { eob = " ", fold = " ", foldsep = " " }

-- インデント設定
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.shiftround = true

-- 検索設定
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 折りたたみ設定
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- ファイル設定
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undo")
vim.opt.undolevels = 10000

-- 編集設定
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2
vim.opt.concealcursor = "niv"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.whichwrap:append({ "<", ">", "h", "l" })

-- タイムアウト設定
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200

-- スクロール設定
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll = true

-- ウィンドウ設定
vim.opt.winminwidth = 5
vim.opt.winwidth = 10
vim.opt.equalalways = false
vim.opt.laststatus = 3
vim.opt.showtabline = 2

-- コマンドライン設定
vim.opt.cmdheight = 1
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false

-- 検索・置換設定
vim.opt.inccommand = "split"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- デバッグ設定
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.pumblend = 10
vim.opt.pumheight = 10

-- VSCode風のカーソル設定
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- 日本語設定
vim.opt.ambiwidth = "single"
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- パフォーマンス設定
vim.opt.lazyredraw = false
vim.opt.synmaxcol = 240
vim.opt.ttyfast = true

-- セッション設定
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- 自動コマンド設定
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ファイルタイプ別設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- 大きなファイルのパフォーマンス最適化
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
      vim.opt_local.eventignore:append("FileType")
      vim.opt_local.undolevels = -1
      vim.opt_local.syntax = "off"
    end
  end,
})

-- ターミナル設定
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- 自動保存設定
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command("silent update")
    end
  end,
})

-- Neovim固有の設定
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

-- VSCode風のグローバル設定
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
