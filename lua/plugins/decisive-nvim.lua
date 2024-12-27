return {
  "emmanueltouzery/decisive.nvim",
  config = function()
    require("decisive").setup({})
  end,
  lazy = true,
  keys = {
    {
      "<leader>cca",
      function()
        require("decisive").align_csv({})
      end,
      { silent = true },
      desc = "Align CSV",
      mode = "n",
      ft = { "csv" },
    },
    {
      "<leader>ccA",
      function()
        require("decisive").align_csv_clear({})
      end,
      { silent = true },
      desc = "Align CSV clear",
      mode = "n",
      ft = { "csv" },
    },
    {
      "[c",
      function()
        require("decisive").align_csv_prev_col()
      end,
      { silent = true },
      desc = "Align CSV prev col",
      mode = "n",
      ft = { "csv" },
    },
    {
      "]c",
      function()
        require("decisive").align_csv_next_col()
      end,
      { silent = true },
      desc = "Align CSV next col",
      mode = "n",
      ft = { "csv" },
    },
  },
}
