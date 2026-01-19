-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Appearance
opt.number = true
opt.cursorline = true

-- Clipboard (share with OS)
opt.clipboard:append("unnamedplus,unnamed")

-- Indent (2-spaces)
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- Scroll
opt.scrolloff = 3

-- Text wrapping (行の折り返し)
opt.wrap = true
opt.breakindent = true
opt.showbreak = "↪ "

-- Cursor movement (move across line boundaries)
opt.whichwrap = "b,s,h,l,<,>,[,],~"

-- Spell check (exclude CJK characters from spell checking)
opt.spelllang = { "en", "cjk" }
