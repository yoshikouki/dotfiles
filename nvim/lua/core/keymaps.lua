-- Keymaps
local keymap = vim.keymap.set

-- Helper: abbreviation only for ex-command
local function abbrev_excmd(lhs, rhs, opts)
  keymap('ca', lhs, function()
    return vim.fn.getcmdtype() == ':' and rhs or lhs
  end, vim.tbl_extend('force', { expr = true }, opts))
end

-- Mixed mode (Normal + Visual)
keymap({ 'n', 'x' }, 'so', ':source<cr>', { silent = true, desc = 'Source current script' })

-- Normal mode
keymap('n', 'p', 'p`]', { desc = 'Paste and move to the end' })
keymap('n', 'P', 'P`]', { desc = 'Paste and move to the end' })
keymap('n', '<space>;', '@:', { desc = 'Re-run the last command' })
keymap('n', '<space>w', '<cmd>write<cr>', { desc = 'Write' })

-- Visual mode
keymap('x', 'p', 'P', { desc = 'Paste without change register' })
keymap('x', 'P', 'p', { desc = 'Paste with change register' })

-- Command mode (Emacs-like)
keymap('c', '<c-b>', '<left>', { desc = 'Emacs like left' })
keymap('c', '<c-f>', '<right>', { desc = 'Emacs like right' })
keymap('c', '<c-a>', '<home>', { desc = 'Emacs like home' })
keymap('c', '<c-e>', '<end>', { desc = 'Emacs like end' })
keymap('c', '<c-h>', '<bs>', { desc = 'Emacs like bs' })
keymap('c', '<c-d>', '<del>', { desc = 'Emacs like del' })

-- Abbreviation
abbrev_excmd('qw', 'wq', { desc = 'fix typo' })
