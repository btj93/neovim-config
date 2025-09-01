return {
  "nvim-mini/mini.diff",
  lazy = false,
  opts = {
    view = {
      style = "sign",
      signs = {
        add = "▎",
        change = "▎",
        delete = "",
      },
    },
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
      "<leader>gd",
      function()
        require("mini.diff").toggle_overlay(0)
      end,
      desc = "Open diff",
      mode = "n",
    },
  },
}
