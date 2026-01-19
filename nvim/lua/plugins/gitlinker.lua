return {
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>yp",
        function()
          require("gitlinker").get_buf_range_url("n")
        end,
        mode = "n",
        desc = "Copy GitHub permalink",
      },
      {
        "<leader>yp",
        function()
          require("gitlinker").get_buf_range_url("v")
        end,
        mode = "v",
        desc = "Copy GitHub permalink (selection)",
      },
    },
    opts = {
      mappings = nil,
    },
  },
}
