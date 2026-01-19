return {
  -- Disable automatic linting for markdown files
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Remove markdownlint from markdown linters
      if opts.linters_by_ft and opts.linters_by_ft.markdown then
        opts.linters_by_ft.markdown = vim.tbl_filter(function(linter)
          return linter ~= "markdownlint" and linter ~= "markdownlint-cli2"
        end, opts.linters_by_ft.markdown)
      end
      return opts
    end,
  },

  -- Keep markdownlint available for explicit formatting only
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "markdownlint" },
      },
    },
  },
}
