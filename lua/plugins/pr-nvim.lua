return {
  "btj93/pr.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {},
  event = "VeryLazy",
  keys = {
    {
      "<leader>gc",
      function()
        require("pr").toggle()
      end,
      { desc = "toggle PR comments" },
    },
    {
      "<leader>gp",
      function()
        require("pr").popup()
      end,
      { desc = "Show comment thread in floating window" },
    },
    {
      "<leader>fg",
      function()
        require("pr.picker").picker()
      end,
      { desc = "Check PR" },
    },
    {
      "]c",
      function()
        require("pr").cycle_comments_in_buffer("forward")
      end,
    },
    {
      "[c",
      function()
        require("pr").cycle_comments_in_buffer("backward")
      end,
    },
    {
      "<leader>c",
      function()
        require("pr").comment()
      end,
      mode = "v",
    },
  },
  dev = true,
}
