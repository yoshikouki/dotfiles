-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function enable_wrap()
  if vim.bo.buftype ~= "" then
    return
  end
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
end

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("AlwaysWrap", { clear = true }),
  callback = enable_wrap,
})

vim.schedule(enable_wrap)
