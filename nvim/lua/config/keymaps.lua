-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set

-- Helper: abbreviation only for ex-command
local function abbrev_excmd(lhs, rhs, opts)
  keymap("ca", lhs, function()
    return vim.fn.getcmdtype() == ":" and rhs or lhs
  end, vim.tbl_extend("force", { expr = true }, opts))
end

-- Mixed mode (Normal + Visual)
keymap({ "n", "x" }, "so", ":source<cr>", { silent = true, desc = "Source current script" })

-- Normal mode
keymap("n", "p", "p`]", { desc = "Paste and move to the end" })
keymap("n", "P", "P`]", { desc = "Paste and move to the end" })
keymap("n", "<space>;", "@:", { desc = "Re-run the last command" })
keymap("n", "<space>w", "<cmd>write<cr>", { desc = "Write" })

-- Visual mode
keymap("x", "p", "P", { desc = "Paste without change register" })
keymap("x", "P", "p", { desc = "Paste with change register" })

-- Command mode (Emacs-like)
keymap("c", "<c-b>", "<left>", { desc = "Emacs like left" })
keymap("c", "<c-f>", "<right>", { desc = "Emacs like right" })
keymap("c", "<c-a>", "<home>", { desc = "Emacs like home" })
keymap("c", "<c-e>", "<end>", { desc = "Emacs like end" })
keymap("c", "<c-h>", "<bs>", { desc = "Emacs like bs" })
keymap("c", "<c-d>", "<del>", { desc = "Emacs like del" })

-- Abbreviation
abbrev_excmd("qw", "wq", { desc = "fix typo" })

-- Claude Code: nvim 設定ヘルプモード
-- <leader>ah で ~/.config/nvim をワーキングディレクトリとして Claude Code を開く
vim.keymap.set("n", "<leader>ah", function()
  local nvim_config_path = vim.fn.stdpath("config")

  local ok, terminal = pcall(require, "claudecode.terminal")
  if not ok then
    vim.notify("claudecode.nvim is not available", vim.log.levels.ERROR)
    return
  end

  -- 現在のファイルが nvim 設定ファイルならコンテキストに追加
  local current_file = vim.fn.expand("%:p")
  if current_file ~= "" and current_file:find(nvim_config_path, 1, true) then
    vim.defer_fn(function()
      vim.cmd("ClaudeCodeAdd " .. vim.fn.fnameescape(current_file))
    end, 100)
  end

  -- Claude Code を nvim 設定ディレクトリで開く
  terminal.open({ cwd = nvim_config_path })
end, { desc = "Claude: nvim config help" })

-- Copy relative path
vim.keymap.set({ "n", "v" }, "<leader>yr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

-- Copy absolute path
vim.keymap.set({ "n", "v" }, "<leader>yR", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })
