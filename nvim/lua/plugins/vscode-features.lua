return {
  -- VSCode風の通知システム
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#1e1e1e",
      render = "compact",
      stages = "fade_in_slide_out",
      timeout = 3000,
      top_down = true,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    },
  },

  -- VSCode風のコマンドパレット
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    opts = {
      defaults = {
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          ".cache",
          "%.o",
          "%.a",
          "%.out",
          "%.class",
          "%.pdf",
          "%.mkv",
          "%.mp4",
          "%.zip",
        },
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        mappings = {
          i = {
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous",
            ["<C-q>"] = "close",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["<CR>"] = "select_default",
            ["<C-s>"] = "select_horizontal",
            ["<C-v>"] = "select_vertical",
            ["<C-t>"] = "select_tab",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["<PageUp>"] = "results_scrolling_up",
            ["<PageDown>"] = "results_scrolling_down",
            ["<Tab>"] = "toggle_selection",
            ["<S-Tab>"] = "toggle_selection",
            ["<C-c>"] = "close",
            ["<C-l>"] = "complete_tag",
            ["<C-_>"] = "which_key",
          },
          n = {
            ["<esc>"] = "close",
            ["<CR>"] = "select_default",
            ["<C-s>"] = "select_horizontal",
            ["<C-v>"] = "select_vertical",
            ["<C-t>"] = "select_tab",
            ["<Tab>"] = "toggle_selection",
            ["<S-Tab>"] = "toggle_selection",
            ["<C-q>"] = "send_to_qflist",
            ["j"] = "move_selection_next",
            ["k"] = "move_selection_previous",
            ["H"] = "move_to_top",
            ["M"] = "move_to_middle",
            ["L"] = "move_to_bottom",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["gg"] = "move_to_top",
            ["G"] = "move_to_bottom",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["<PageUp>"] = "results_scrolling_up",
            ["<PageDown>"] = "results_scrolling_down",
            ["?"] = "which_key",
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          theme = "ivy",
          only_sort_text = true,
        },
        grep_string = {
          theme = "ivy",
          only_sort_text = true,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer",
            },
            n = {
              ["dd"] = "delete_buffer",
            },
          },
        },
        planets = {
          show_pluto = true,
          show_moon = true,
        },
        git_files = {
          theme = "ivy",
          hidden = true,
          previewer = false,
          show_untracked = true,
        },
        lsp_references = {
          theme = "ivy",
          initial_mode = "normal",
        },
        lsp_definitions = {
          theme = "ivy",
          initial_mode = "normal",
        },
        lsp_declarations = {
          theme = "ivy",
          initial_mode = "normal",
        },
        lsp_implementations = {
          theme = "ivy",
          initial_mode = "normal",
        },
      },
      extensions = {
        ["ui-select"] = {},
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        project = {
          base_dirs = {
            "~/projects",
            "~/work",
            "~/",
          },
          hidden_files = true,
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true,
        },
        frecency = {
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
          disable_devicons = false,
          workspaces = {
            ["conf"] = "/home/yoshikouki/.config",
            ["project"] = "/home/yoshikouki/projects",
            ["work"] = "/home/yoshikouki/work",
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local sorters = require("telescope.sorters")
      local previewers = require("telescope.previewers")
      local themes = require("telescope.themes")

      -- opts.defaults に require が必要な設定を追加
      opts.defaults = vim.tbl_extend("force", opts.defaults or {}, {
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
      })

      -- extensions.ui-select に設定を追加
      opts.extensions = opts.extensions or {}
      opts.extensions["ui-select"] = { themes.get_dropdown({}) }

      telescope.setup(opts)
      telescope.load_extension("ui-select")
      local ok = pcall(telescope.load_extension, "fzf")
      if not ok then
        vim.notify("telescope-fzf-native not available", vim.log.levels.WARN)
      end
      telescope.load_extension("project")
      telescope.load_extension("frecency")
    end,
  },

  -- VSCode風のブレッドクラム
  {
    "LunarVim/breadcrumbs.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      icons = {
        Array = " ",
        Boolean = " ",
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Key = " ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Namespace = " ",
        Null = " ",
        Number = " ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        String = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      },
      highlight = true,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    },
  },

  -- VSCode風のタブ機能強化
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<C-w>", "<cmd>bdelete<cr>", desc = "Delete buffer" },
      { "<C-S-t>", "<cmd>enew<cr>", desc = "New buffer" },
    },
  },

  -- VSCode風のインデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- VSCode風のコードアクション
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = { enabled = true },
      sign = {
        enabled = false,
        priority = 10,
      },
      float = {
        enabled = false,
        text = "💡",
        win_opts = {},
      },
      virtual_text = {
        enabled = true,
        text = "💡",
        pos = "eol",
      },
      status_text = {
        enabled = false,
        text = "💡",
        text_unavailable = "",
      },
      line = {
        enabled = false,
      },
    },
  },

  -- VSCode風のスムーズスクロール
  {
    "karb94/neoscroll.nvim",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      use_local_scrolloff = false,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = nil,
      pre_hook = nil,
      post_hook = nil,
    },
  },

}