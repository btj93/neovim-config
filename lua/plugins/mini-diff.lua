return {
  "echasnovski/mini.diff",
  lazy = false,
  opts = {
    mappings = {
      -- Apply hunks inside a visual/operator region
      apply = "'",

      -- Reset hunks inside a visual/operator region
      reset = "''",

      -- Hunk range textobject to be used inside operator
      -- Works also in Visual mode if mapping differs from apply and reset
      textobject = "''",

      -- Go to hunk range in corresponding direction
      goto_first = "''",
      goto_prev = "''",
      goto_next = "''",
      goto_last = "''",
    },
  },
  keys = {
    {
      "<leader>go",
      function()
        require("mini.diff").toggle_overlay()
      end,
      desc = "Open diff",
      mode = "n",
    },
  },
}
