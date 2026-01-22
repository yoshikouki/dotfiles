-- Neo-tree state persistence helpers
local neotree_state_dir = vim.fn.stdpath("state") .. "/neotree-state"
local state_restored = false

local function get_state_file()
  local cwd = vim.fn.getcwd():gsub("[\\/:]+", "%%")
  return neotree_state_dir .. "/" .. cwd .. ".json"
end

local function load_saved_state()
  local file = get_state_file()
  if vim.fn.filereadable(file) == 0 then
    return nil
  end
  local lines = vim.fn.readfile(file)
  if #lines == 0 then
    return nil
  end
  local ok, data = pcall(vim.fn.json_decode, lines[1])
  if ok and data then
    return data
  end
  return nil
end

local function save_state(state)
  if not state or not state.tree then
    return
  end
  local renderer = require("neo-tree.ui.renderer")
  local expanded_nodes = renderer.get_expanded_nodes(state.tree)

  vim.fn.mkdir(neotree_state_dir, "p")
  local file = get_state_file()
  local data = { expanded_nodes = expanded_nodes, path = state.path }
  vim.fn.writefile({ vim.fn.json_encode(data) }, file)
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  init = function()
    -- Save state on VimLeavePre (before window closes)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("neotree_state_save", { clear = true }),
      callback = function()
        local ok, manager = pcall(require, "neo-tree.sources.manager")
        if not ok then
          return
        end
        local state = manager.get_state("filesystem")
        save_state(state)
      end,
    })
  end,
  opts = {
    -- ========================================
    -- 全般設定
    -- ========================================
    close_if_last_window = true, -- 最後のウィンドウなら Neo-tree を閉じる
    -- popup_border_style = "NC",            -- ポップアップのボーダースタイル
    enable_git_status = true, -- Git ステータスを有効化
    enable_diagnostics = true, -- 診断情報を有効化
    -- sort_case_insensitive = false,        -- 大文字小文字を区別してソート

    event_handlers = {
      {
        event = "before_render",
        handler = function(state)
          if state_restored then
            return
          end
          local saved = load_saved_state()
          if saved and saved.expanded_nodes then
            state.force_open_folders = saved.expanded_nodes
            state_restored = true
          end
        end,
      },
      {
        event = "neo_tree_window_before_close",
        handler = function()
          local manager = require("neo-tree.sources.manager")
          local state = manager.get_state("filesystem")
          save_state(state)
        end,
      },
    },

    -- ========================================
    -- コンポーネント設定 (default_component_configs)
    -- ========================================
    default_component_configs = {
      --   container = {
      --     enable_character_fade = true,     -- 文字フェード効果
      --   },
      --   indent = {
      --     indent_size = 2,                  -- インデントサイズ
      --     padding = 1,                      -- 左パディング
      --     with_markers = true,              -- インデントマーカーを表示
      --     indent_marker = "│",
      --     last_indent_marker = "└",
      --     with_expanders = nil,             -- ファイルネスト用エキスパンダー
      --     expander_collapsed = "",
      --     expander_expanded = "",
      --   },
      --   icon = {
      --     folder_closed = "",
      --     folder_open = "",
      --     folder_empty = "󰜌",
      --     default = "*",
      --   },
      --   modified = {
      --     symbol = "[+]",
      --   },
      --   name = {
      --     trailing_slash = false,           -- ディレクトリ末尾にスラッシュ
      --     use_git_status_colors = true,     -- Git ステータスに応じた色
      --   },
      --   git_status = {
      --     symbols = {
      --       added     = "",
      --       modified  = "",
      --       deleted   = "✖",
      --       renamed   = "󰁕",
      --       untracked = "",
      --       ignored   = "",
      --       unstaged  = "󰄱",
      --       staged    = "",
      --       conflict  = "",
      --     },
      --   },
      --   diagnostics = {
      --     symbols = {
      --       hint = "H",
      --       info = "I",
      --       warn = "!",
      --       error = "X",
      --     },
      --   },
      --   -- ファイル情報カラム
      --   file_size = { enabled = true, width = 12, required_width = 64 },
      --   type = { enabled = true, width = 10, required_width = 122 },
      --   last_modified = { enabled = true, width = 20, required_width = 88 },
      --   created = { enabled = true, width = 20, required_width = 110 },
      --   symlink_target = { enabled = false },
    },

    -- ========================================
    -- ウィンドウ設定
    -- ========================================
    -- window = {
    --   position = "left",                  -- "left", "right", "top", "bottom", "float", "current"
    --   width = 40,                         -- サイドバーの幅
    --   mappings = {
    --     ["<space>"] = { "toggle_node", nowait = false },
    --     ["<2-LeftMouse>"] = "open",
    --     ["<cr>"] = "open",
    --     ["<esc>"] = "cancel",
    --     ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
    --     ["S"] = "open_split",
    --     ["s"] = "open_vsplit",
    --     ["t"] = "open_tabnew",
    --     ["w"] = "open_with_window_picker",
    --     ["C"] = "close_node",
    --     ["z"] = "close_all_nodes",
    --     ["Z"] = "expand_all_nodes",
    --     ["a"] = { "add", config = { show_path = "none" } },  -- "none", "relative", "absolute"
    --     ["A"] = "add_directory",
    --     ["d"] = "delete",
    --     ["r"] = "rename",
    --     ["y"] = "copy_to_clipboard",
    --     ["x"] = "cut_to_clipboard",
    --     ["p"] = "paste_from_clipboard",
    --     ["c"] = "copy",
    --     ["m"] = "move",
    --     ["q"] = "close_window",
    --     ["R"] = "refresh",
    --     ["?"] = "show_help",
    --     ["<"] = "prev_source",
    --     [">"] = "next_source",
    --     ["i"] = "show_file_details",
    --   },
    -- },

    -- ========================================
    -- ファイルシステム設定
    -- ========================================
    filesystem = {
      filtered_items = {
        visible = true, -- 隠しファイルをグレーアウト表示
        hide_dotfiles = false, -- dotfiles を表示
        hide_gitignored = false, -- gitignore されたファイルを表示
        hide_hidden = false, -- OS の隠しファイルを表示 (Windows)
        -- hide_by_name = {                 -- 特定の名前を非表示
        --   ".DS_Store",
        --   "thumbs.db",
        --   "node_modules",
        -- },
        -- hide_by_pattern = {              -- パターンで非表示
        --   "*.meta",
        --   "*/src/*/tsconfig.json",
        -- },
        always_show = { -- 常に表示
          ".gitignore",
        },
        always_show_by_pattern = { -- パターンで常に表示
          ".env*",
        },
        -- never_show = {                   -- 絶対に非表示
        --   ".DS_Store",
        --   "thumbs.db",
        -- },
        -- never_show_by_pattern = {        -- パターンで絶対に非表示
        --   ".null-ls_*",
        -- },
      },
      follow_current_file = {
        --   enabled = false,                 -- カレントファイルを追従
        leave_dirs_open = false, -- ディレクトリを開いたままにする
      },
      -- group_empty_dirs = false,          -- 空ディレクトリをグループ化
      -- hijack_netrw_behavior = "open_default",  -- "open_default", "open_current", "disabled"
      -- use_libuv_file_watcher = false,    -- ファイル変更を自動検知
      -- window = {
      --   mappings = {
      --     ["<bs>"] = "navigate_up",
      --     ["."] = "set_root",
      --     ["H"] = "toggle_hidden",
      --     ["/"] = "fuzzy_finder",
      --     ["D"] = "fuzzy_finder_directory",
      --     ["#"] = "fuzzy_sorter",
      --     ["f"] = "filter_on_submit",
      --     ["<c-x>"] = "clear_filter",
      --     ["[g"] = "prev_git_modified",
      --     ["]g"] = "next_git_modified",
      --     ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
      --     ["oc"] = { "order_by_created", nowait = false },
      --     ["od"] = { "order_by_diagnostics", nowait = false },
      --     ["og"] = { "order_by_git_status", nowait = false },
      --     ["om"] = { "order_by_modified", nowait = false },
      --     ["on"] = { "order_by_name", nowait = false },
      --     ["os"] = { "order_by_size", nowait = false },
      --     ["ot"] = { "order_by_type", nowait = false },
      --   },
      --   fuzzy_finder_mappings = {
      --     ["<down>"] = "move_cursor_down",
      --     ["<C-n>"] = "move_cursor_down",
      --     ["<up>"] = "move_cursor_up",
      --     ["<C-p>"] = "move_cursor_up",
      --   },
      -- },
    },

    -- ========================================
    -- バッファ設定
    -- ========================================
    -- buffers = {
    --   follow_current_file = {
    --     enabled = true,                  -- アクティブバッファを追従
    --     leave_dirs_open = false,
    --   },
    --   group_empty_dirs = true,           -- 空ディレクトリをグループ化
    --   show_unloaded = true,              -- アンロードされたバッファを表示
    --   window = {
    --     mappings = {
    --       ["d"] = "buffer_delete",
    --       ["bd"] = "buffer_delete",
    --       ["<bs>"] = "navigate_up",
    --       ["."] = "set_root",
    --     },
    --   },
    -- },

    -- ========================================
    -- Git ステータス設定
    -- ========================================
    -- git_status = {
    --   window = {
    --     position = "float",
    --     mappings = {
    --       ["A"] = "git_add_all",
    --       ["gu"] = "git_unstage_file",
    --       ["ga"] = "git_add_file",
    --       ["gr"] = "git_revert_file",
    --       ["gc"] = "git_commit",
    --       ["gp"] = "git_push",
    --       ["gg"] = "git_commit_and_push",
    --     },
    --   },
    -- },

    -- ========================================
    -- ソースセレクター設定
    -- ========================================
    -- source_selector = {
    --   winbar = false,                    -- ウィンバーに表示
    --   statusline = false,                -- ステータスラインに表示
    --   sources = {
    --     { source = "filesystem", display_name = " 󰉓 Files " },
    --     { source = "buffers", display_name = " 󰈚 Buffers " },
    --     { source = "git_status", display_name = " 󰊢 Git " },
    --   },
    -- },
  },
}
