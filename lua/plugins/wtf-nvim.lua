return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim", -- Optional: For WtfGrepHistory
  },
  opts = {
    provider = "gemini",
  },
  keys = {
    {
      "<leader>cAd",
      mode = { "n", "x" },
      function()
        require("wtf").diagnose()
      end,
      desc = "Debug diagnostic with AI",
    },
    {
      "<leader>cAf",
      mode = { "n", "x" },
      function()
        require("wtf").fix()
      end,
      desc = "Fix diagnostic with AI",
    },
    {
      "<leader>cAs",
      mode = { "n" },
      function()
        require("wtf").search()
      end,
      desc = "Search diagnostic with Google",
    },
    {
      "<leader>cAh",
      mode = { "n" },
      function()
        require("wtf").history()
      end,
      desc = "Populate the quickfix list with previous chat history",
    },
    {
      "<leader>cAt",
      mode = { "n" },
      function()
        require("wtf").grep_history()
      end,
      desc = "Grep previous chat history with Telescope",
    },
  },
}
