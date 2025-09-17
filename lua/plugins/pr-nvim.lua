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
        require("pr").picker()
      end,
      { desc = "Check PR" },
    },
  },
  dev = true,
}
