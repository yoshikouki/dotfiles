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

-- Neo-tree state persistence
local neotree_state_dir = vim.fn.stdpath("state") .. "/neotree-state"

local function get_neotree_state_file()
  local cwd = vim.fn.getcwd():gsub("[\\/:]+", "%%")
  return neotree_state_dir .. "/" .. cwd .. ".json"
end

local function save_neotree_state()
  local ok, manager = pcall(require, "neo-tree.sources.manager")
  if not ok then
    return
  end
  local renderer_ok, renderer = pcall(require, "neo-tree.ui.renderer")
  if not renderer_ok then
    return
  end

  local state = manager.get_state("filesystem")
  if not state or not state.tree then
    return
  end

  local expanded_nodes = renderer.get_expanded_nodes(state.tree)
  local data = {
    path = state.path,
    expanded_nodes = expanded_nodes,
  }

  vim.fn.mkdir(neotree_state_dir, "p")
  local file = get_neotree_state_file()
  local json = vim.fn.json_encode(data)
  vim.fn.writefile({ json }, file)
end

local function restore_neotree_state()
  local file = get_neotree_state_file()
  if vim.fn.filereadable(file) == 0 then
    return
  end

  local ok, manager = pcall(require, "neo-tree.sources.manager")
  if not ok then
    return
  end

  local lines = vim.fn.readfile(file)
  if #lines == 0 then
    return
  end

  local success, data = pcall(vim.fn.json_decode, lines[1])
  if not success or not data then
    return
  end

  -- Schedule to run after neo-tree is fully loaded
  vim.defer_fn(function()
    local state = manager.get_state("filesystem")
    if state and data.expanded_nodes then
      state.force_open_folders = data.expanded_nodes
      if state.tree then
        require("neo-tree.sources.filesystem").refresh(state)
      end
    end
  end, 100)
end

-- Save neo-tree state before session save
vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceSavePre",
  callback = save_neotree_state,
  desc = "Save neo-tree expanded state",
})

-- Restore neo-tree state after session load
vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceLoadPost",
  callback = restore_neotree_state,
  desc = "Restore neo-tree expanded state",
})

-- Also save on VimLeavePre for cases where persistence is not used
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("neotree_state", { clear = true }),
  callback = save_neotree_state,
  desc = "Save neo-tree state on exit",
})

-- Restore state on VimEnter if neo-tree is opened
vim.api.nvim_create_autocmd("User", {
  pattern = "NeotreeWindowCreated",
  once = true,
  callback = function()
    vim.defer_fn(restore_neotree_state, 200)
  end,
  desc = "Restore neo-tree state when window is created",
})

