-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup("core", { clear = true })

local function autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", {
    group = augroup,
  }, opts))
end

-- User commands
vim.api.nvim_create_user_command("InitLua", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Open init.lua" })

-- Auto mkdir: create parent directories when saving file
-- https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
autocmd("BufWritePre", {
  pattern = "*",
  callback = function(event)
    local dir = vim.fs.dirname(event.file)
    local force = vim.v.cmdbang == 1
    if
      vim.fn.isdirectory(dir) == 0
      and (force or vim.fn.confirm('"' .. dir .. '" does not exist. Create?', "&Yes\n&No") == 1)
    then
      vim.fn.mkdir(vim.fn.iconv(dir, vim.opt.encoding:get(), vim.opt.termencoding:get()), "p")
    end
  end,
  desc = "Auto mkdir to save file",
})

-- Auto save when focus is lost
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  callback = function(event)
    local buf = event.buf
    if
      vim.bo[buf].modified
      and not vim.bo[buf].readonly
      and vim.fn.bufname(buf) ~= ""
      and vim.bo[buf].buftype == ""
    then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent! write")
      end)
    end
  end,
})

-- Disable spell check for markdown files (Japanese text causes underlines)
autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.spell = false
    -- Enable auto-continuing lists on new lines
    vim.opt_local.formatoptions:append("ron")
    vim.opt_local.comments = "b:*,b:-,b:+,n:>"
  end,
  desc = "Disable spell check for markdown and enable list continuation",
})

-- Open neo-tree on startup when no file arguments
autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("Neotree show")
    end
  end,
  desc = "Open neo-tree on startup",
})

