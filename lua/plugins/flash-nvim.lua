return {
  "folke/flash.nvim",
  opts = {
    search = {
      -- Each mode will take ignorecase and smartcase into account.
      -- * exact: exact match
      -- * search: regular search
      -- * fuzzy: fuzzy search
      -- * fun(str): custom function that returns a pattern
      --   For example, to only match at the beginning of a word:
      --   mode = function(str)
      --     return "\\<" .. str
      --   end,
      mode = "fuzzy",
    },
    label = {
      -- rainbow = {
      --   enabled = true,
      --   -- number between 1 and 9
      --   shade = 5,
      -- },
      style = "inline", ---@type "eol" | "overlay" | "right_align" | "inline"
      before = true,
      after = false,
      current = true,
    },
    highlight = {
      -- show a backdrop with hl FlashBackdrop
      backdrop = true,
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
  config = function(_, opts)
    require("flash").setup(opts)
  end,
}
