-- Neovim options
local opt = vim.opt

-- Appearance
opt.number = true
opt.cursorline = true

-- Clipboard (share with OS)
opt.clipboard:append('unnamedplus,unnamed')

-- Indent (2-spaces)
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- Scroll
opt.scrolloff = 3

-- Cursor movement (move across line boundaries)
opt.whichwrap = 'b,s,h,l,<,>,[,],~'

