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
      "<leader>uh",
      function()
        require("pr").toggle_hunks()
      end,
      { desc = "toggle PR hunks" },
    },
    {
      "<leader>uc",
      function()
        require("pr").toggle_comments()
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
      "<leader>fh",
      function()
        require("pr.picker").pick_hunks()
      end,
      { desc = "Pick PR hunks" },
    },
    {
      "<leader>fg",
      function()
        require("pr.picker").pick_comments()
      end,
      { desc = "Pick PR comments" },
    },
    {
      "]ph",
      function()
        require("pr").cycle_hunks_in_buffer("forward")
      end,
    },
    {
      "[ph",
      function()
        require("pr").cycle_hunks_in_buffer("backward")
      end,
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
      "<leader>nc",
      function()
        require("pr").comment()
      end,
      mode = "v",
    },
  },
  dev = true,
}
