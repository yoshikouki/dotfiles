return {
  -- VSCode風テーマ
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = false,
        italic_comments = true,
        disable_nvimtree_bg = true,
        group_overrides = {
          Cursor = { fg = "#515052", bg = "#AEAFAD" },
          Search = { fg = "#515052", bg = "#AEAFAD" },
          IncSearch = { fg = "#515052", bg = "#AEAFAD" },
          CurSearch = { fg = "#515052", bg = "#AEAFAD" },
        },
      })
    end,
  },

  -- LazyVim用のテーマ設定
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },

  -- VSCode風のアイコン
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = {
        js = { icon = "", color = "#f7df1e", name = "JavaScript" },
        ts = { icon = "", color = "#3178c6", name = "TypeScript" },
        jsx = { icon = "", color = "#61dafb", name = "React" },
        tsx = { icon = "", color = "#61dafb", name = "ReactTS" },
        vue = { icon = "", color = "#4fc08d", name = "Vue" },
        py = { icon = "", color = "#3776ab", name = "Python" },
        json = { icon = "", color = "#cbcb41", name = "Json" },
        md = { icon = "", color = "#519aba", name = "Markdown" },
        html = { icon = "", color = "#e34c26", name = "Html" },
        css = { icon = "", color = "#1572b6", name = "Css" },
        scss = { icon = "", color = "#c6538c", name = "Scss" },
        go = { icon = "", color = "#00add8", name = "Go" },
        rs = { icon = "", color = "#ce422b", name = "Rust" },
        toml = { icon = "", color = "#9c4221", name = "Toml" },
        yaml = { icon = "", color = "#cc1018", name = "Yaml" },
        yml = { icon = "", color = "#cc1018", name = "Yml" },
        dockerfile = { icon = "", color = "#384d54", name = "Dockerfile" },
        ["docker-compose.yml"] = { icon = "", color = "#384d54", name = "DockerCompose" },
        [".env"] = { icon = "", color = "#faf743", name = "Env" },
        [".gitignore"] = { icon = "", color = "#f1502f", name = "GitIgnore" },
        ["package.json"] = { icon = "", color = "#e8274b", name = "PackageJson" },
        ["tsconfig.json"] = { icon = "", color = "#3178c6", name = "TypeScriptConfig" },
      },
    },
  },

  -- VSCode風のステータスライン
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "vscode",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = "●", readonly = "" } },
        },
        lualine_x = {
          { "encoding", show_bomb = true },
          { "fileformat", icons_enabled = true },
          { "filetype", icon_only = false },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy", "trouble", "mason" },
    },
  },

  -- VSCode風のタブライン
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "tabs",
        separator_style = "thin",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
      },
      highlights = {
        fill = { bg = "#1e1e1e" },
        background = { bg = "#2d2d30" },
        tab = { bg = "#2d2d30" },
        tab_selected = { bg = "#1e1e1e", fg = "#ffffff" },
        close_button = { bg = "#2d2d30" },
        close_button_selected = { bg = "#1e1e1e" },
        separator = { bg = "#2d2d30", fg = "#1e1e1e" },
        separator_selected = { bg = "#1e1e1e", fg = "#1e1e1e" },
      },
    },
  },

  -- VSCode風のファイルツリー
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      sort_case_insensitive = false,
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "●",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false,
          },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["l"] = "focus_preview",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["a"] = {
            "add",
            config = {
              show_path = "none",
            },
          },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
          ["i"] = "show_file_details",
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          hide_by_name = {
            "node_modules",
            ".git",
            ".DS_Store",
            ".vscode",
          },
          hide_by_pattern = {
            "*.meta",
            "*/src/*/tsconfig.json",
          },
          always_show = {
            ".gitignore",
            ".env",
          },
          never_show = {
            ".DS_Store",
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = false,
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "fuzzy_sorter",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["og"] = { "order_by_git_status", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },
    },
  },
}