return {
  "folke/flash.nvim",
  opts = {
    label = {
      -- rainbow = {
      --   enabled = true,
      --   -- number between 1 and 9
      --   shade = 5,
      -- },
    },
    modes = {
      -- options used when flash is activated through
      -- a regular search with `/` or `?`
      -- options used when flash is activated through
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        enabled = false,
      },
    },
  },
}
