return {
  -- VSCode風のキーマップ設定
  {
    "LazyVim/LazyVim",
    opts = function()
      -- VSCode風のキーマップを設定
      local keymap = vim.keymap.set
      
      -- コマンドパレット（VSCode: Ctrl+Shift+P）
      keymap("n", "<C-S-p>", function() Snacks.picker.commands() end, { desc = "Command Palette" })
      keymap("n", "<leader><leader>", "<cmd>Telescope commands<cr>", { desc = "Command Palette" })
      
      -- ファイル検索（VSCode: Ctrl+P）
      keymap("n", "<C-p>", function() Snacks.picker.files() end, { desc = "Find Files" })
      keymap("n", "<leader>p", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
      
      -- プロジェクト内検索（VSCode: Ctrl+Shift+F）
      keymap("n", "<C-S-f>", function() Snacks.picker.grep() end, { desc = "Search in Files" })
      keymap("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Search in Files" })
      
      -- ファイル内検索（VSCode: Ctrl+F）
      keymap("n", "<C-f>", function() Snacks.picker.lines() end, { desc = "Search in Buffer" })
      keymap("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in Buffer" })
      
      -- クイックオープン（VSCode: Ctrl+Q）
      keymap("n", "<C-q>", function() Snacks.picker.buffers() end, { desc = "Open Buffers" })
      keymap("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Open Buffers" })
      
      -- ファイルエクスプローラー（VSCode: Ctrl+Shift+E）
      keymap("n", "<C-S-e>", "<cmd>Neotree toggle<cr>", { desc = "Toggle File Explorer" })
      keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle File Explorer" })
      keymap("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Reveal in File Explorer" })
      
      -- ソース管理（VSCode: Ctrl+Shift+G）
      keymap("n", "<C-S-g>", "<cmd>Neotree git_status<cr>", { desc = "Git Status" })
      keymap("n", "<leader>gg", "<cmd>Neotree git_status<cr>", { desc = "Git Status" })
      
      -- ターミナル（VSCode: Ctrl+`）
      keymap("n", "<C-`>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
      keymap("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
      
      -- 新しいファイル（VSCode: Ctrl+N）
      keymap("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })
      
      -- ファイルを保存（VSCode: Ctrl+S）
      keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Save File" })
      keymap("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save File" })
      
      -- 全て保存（VSCode: Ctrl+K S）
      keymap("n", "<C-k>s", "<cmd>wa<cr>", { desc = "Save All Files" })
      
      -- タブを閉じる（VSCode: Ctrl+W）
      keymap("n", "<C-w>", "<cmd>bd<cr>", { desc = "Close Tab" })
      
      -- 新しいタブ（VSCode: Ctrl+T）
      keymap("n", "<C-t>", "<cmd>tabnew<cr>", { desc = "New Tab" })
      
      -- 行の移動（VSCode: Alt+↑/↓）
      keymap("n", "<A-Up>", "<cmd>move .-2<cr>", { desc = "Move Line Up" })
      keymap("n", "<A-Down>", "<cmd>move .+1<cr>", { desc = "Move Line Down" })
      keymap("v", "<A-Up>", ":move '<-2<cr>gv", { desc = "Move Selection Up" })
      keymap("v", "<A-Down>", ":move '>+1<cr>gv", { desc = "Move Selection Down" })
      
      -- 行の複製（VSCode: Shift+Alt+↑/↓）
      keymap("n", "<S-A-Up>", "<cmd>copy .-1<cr>", { desc = "Duplicate Line Up" })
      keymap("n", "<S-A-Down>", "<cmd>copy .<cr>", { desc = "Duplicate Line Down" })
      keymap("v", "<S-A-Up>", ":copy '<-1<cr>gv", { desc = "Duplicate Selection Up" })
      keymap("v", "<S-A-Down>", ":copy '><cr>gv", { desc = "Duplicate Selection Down" })
      
      -- 行の削除（VSCode: Ctrl+Shift+K）
      keymap("n", "<C-S-k>", "<cmd>delete<cr>", { desc = "Delete Line" })
      keymap("v", "<C-S-k>", ":delete<cr>", { desc = "Delete Selection" })
      
      -- コメントアウト（VSCode: Ctrl+/）
      keymap("n", "<C-/>", "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", { desc = "Toggle Comment" })
      keymap("v", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", { desc = "Toggle Comment" })
      
      -- 定義へ移動（VSCode: F12）
      keymap("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" })
      keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" })
      
      -- 参照を探す（VSCode: Shift+F12）
      keymap("n", "<S-F12>", "<cmd>Telescope lsp_references<cr>", { desc = "Find References" })
      keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "Find References" })
      
      -- シンボルの名前変更（VSCode: F2）
      keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename Symbol" })
      
      -- フォーマット（VSCode: Shift+Alt+F）
      keymap("n", "<S-A-f>", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format Document" })
      keymap("v", "<S-A-f>", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format Selection" })
      
      -- クイックフィックス（VSCode: Ctrl+.）
      keymap("n", "<C-.>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
      keymap("v", "<C-.>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
      
      -- 問題パネル（VSCode: Ctrl+Shift+M）
      keymap("n", "<C-S-m>", "<cmd>Trouble diagnostics<cr>", { desc = "Show Problems" })
      keymap("n", "<leader>xx", "<cmd>Trouble diagnostics<cr>", { desc = "Show Problems" })
      
      -- シンボル検索（VSCode: Ctrl+Shift+O）
      keymap("n", "<C-S-o>", function() Snacks.picker.lsp_symbols() end, { desc = "Document Symbols" })
      keymap("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
      
      -- ワークスペース内のシンボル（VSCode: Ctrl+T）
      keymap("n", "<C-S-t>", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
      keymap("n", "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
      
      -- Zen Mode（VSCode: Ctrl+K Z）
      keymap("n", "<C-k>z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })
      
      -- サイドバーの切り替え（VSCode: Ctrl+B）
      keymap("n", "<C-b>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Sidebar" })
      
      -- パネルの切り替え（VSCode: Ctrl+J）
      keymap("n", "<C-j>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Panel" })
      
      -- タブの切り替え（VSCode: Ctrl+Tab）
      keymap("n", "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Tab" })
      keymap("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Tab" })
      
      -- 最近使用したファイル（VSCode: Ctrl+R）
      keymap("n", "<C-r>", function() Snacks.picker.recent() end, { desc = "Recent Files" })
      keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
      
      -- プロジェクトの切り替え
      keymap("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Find Project" })
      keymap("n", "<C-S-r>", "<cmd>Telescope project<cr>", { desc = "Switch Project" })

      -- パスをクリップボードへコピー
      keymap("n", "<leader>yr", "<cmd>lua vim.fn.setreg('+', vim.fn.expand('%'))<cr>", { desc = "Copy Relative Path" })
      keymap("n", "<leader>yR", "<cmd>lua vim.fn.setreg('+', vim.fn.expand('%:p'))<cr>", { desc = "Copy Absolute Path" })
      
      -- 頻繁に使用するファイル
      keymap("n", "<leader>fF", "<cmd>Telescope frecency<cr>", { desc = "Frequent Files" })
      
      -- マルチカーソル風の操作
      keymap("n", "<C-d>", "<cmd>lua require('illuminate').next_reference{wrap=true}<cr>", { desc = "Next Reference" })
      keymap("n", "<C-S-d>", "<cmd>lua require('illuminate').next_reference{reverse=true,wrap=true}<cr>", { desc = "Previous Reference" })
      
      -- 行へ移動（VSCode: Ctrl+G）
      keymap("n", "<C-g>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Go to Line" })
      
      -- 設定を開く（VSCode: Ctrl+,）
      keymap("n", "<C-,>", "<cmd>e $MYVIMRC<cr>", { desc = "Open Settings" })
      
      -- キーボードショートカット（VSCode: Ctrl+K Ctrl+S）
      keymap("n", "<C-k><C-s>", "<cmd>Telescope keymaps<cr>", { desc = "Keyboard Shortcuts" })
      
      -- エラーの次へ移動（VSCode: F8）
      keymap("n", "<F8>", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Error" })
      keymap("n", "<S-F8>", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Error" })
      
      -- デバッグ関連のキーマップ (nvim-dap が必要)
      if pcall(require, 'dap') then
        keymap("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle Breakpoint" })
        keymap("n", "<F5>", "<cmd>lua require('dap').continue()<cr>", { desc = "Start Debug" })
        keymap("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", { desc = "Step Over" })
        keymap("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", { desc = "Step Into" })
        keymap("n", "<S-F11>", "<cmd>lua require('dap').step_out()<cr>", { desc = "Step Out" })
      end
      
      -- 折りたたみ（VSCode: Ctrl+Shift+[/]）
      keymap("n", "<C-S-[>", "<cmd>foldclose<cr>", { desc = "Fold" })
      keymap("n", "<C-S-]>", "<cmd>foldopen<cr>", { desc = "Unfold" })
      
      -- 全て折りたたみ/展開（VSCode: Ctrl+K Ctrl+0/J）
      keymap("n", "<C-k><C-0>", "<cmd>%foldclose<cr>", { desc = "Fold All" })
      keymap("n", "<C-k><C-j>", "<cmd>%foldopen<cr>", { desc = "Unfold All" })
      
      -- 現在の行を中央に（VSCode: Ctrl+L）
      keymap("n", "<C-l>", "zz", { desc = "Center Line" })
      
      -- 選択拡張機能 (syntax-tree-surfer が必要)
      if pcall(require, 'syntax-tree-surfer') then
        keymap("n", "<S-A-Right>", "<cmd>lua require('syntax-tree-surfer').select()<cr>", { desc = "Expand Selection" })
        keymap("v", "<S-A-Right>", "<cmd>lua require('syntax-tree-surfer').select()<cr>", { desc = "Expand Selection" })
        keymap("n", "<S-A-Left>", "<cmd>lua require('syntax-tree-surfer').select_current_node()<cr>", { desc = "Shrink Selection" })
        keymap("v", "<S-A-Left>", "<cmd>lua require('syntax-tree-surfer').select_current_node()<cr>", { desc = "Shrink Selection" })
      end
      
      -- ウィンドウの分割（VSCode: Ctrl+\）
      keymap("n", "<C-\\>", "<cmd>vsplit<cr>", { desc = "Split Window" })
      
      -- ウィンドウ間の移動（VSCode: Ctrl+1,2,3...）
      keymap("n", "<C-1>", "<cmd>1wincmd w<cr>", { desc = "Focus Window 1" })
      keymap("n", "<C-2>", "<cmd>2wincmd w<cr>", { desc = "Focus Window 2" })
      keymap("n", "<C-3>", "<cmd>3wincmd w<cr>", { desc = "Focus Window 3" })
      
      -- 置換（VSCode: Ctrl+H）
      keymap("n", "<C-h>", "<cmd>lua require('spectre').toggle()<cr>", { desc = "Replace in Files" })
      
      -- 選択範囲の置換（VSCode: Ctrl+Shift+L）
      keymap("v", "<C-S-l>", "<cmd>lua require('spectre').open_visual()<cr>", { desc = "Replace Selection" })
      
      -- GitLens風の機能
      keymap("n", "<leader>gb", "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", { desc = "Git Blame Line" })
      keymap("n", "<leader>gB", "<cmd>lua require('gitsigns').toggle_current_line_blame()<cr>", { desc = "Toggle Git Blame" })
      keymap("n", "<leader>gd", "<cmd>lua require('gitsigns').diffthis()<cr>", { desc = "Git Diff" })
      keymap("n", "<leader>gD", "<cmd>lua require('gitsigns').diffthis('~')<cr>", { desc = "Git Diff ~" })
      
      -- アウトライン（VSCode: Ctrl+Shift+.）
      keymap("n", "<C-S-.>", "<cmd>SymbolsOutline<cr>", { desc = "Symbols Outline" })
      keymap("n", "<leader>o", "<cmd>SymbolsOutline<cr>", { desc = "Symbols Outline" })
      
      -- ミニマップの切り替え
      keymap("n", "<leader>mm", "<cmd>MinimapToggle<cr>", { desc = "Toggle Minimap" })
      
      -- 通知の履歴
      keymap("n", "<leader>nh", "<cmd>Telescope notify<cr>", { desc = "Notification History" })
      
      -- LazyVim固有の設定
      keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
      keymap("n", "<leader>L", "<cmd>LazyVim<cr>", { desc = "LazyVim" })
    end,
  },
}
