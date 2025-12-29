return {
  "xzbdmw/clasp.nvim",
  enabled = false,
  opts = {
    pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["<"] = ">" },
    -- If called from insert mode, do not return to normal mode.
    keep_insert_mode = true,
  },
  keys = {
    {
      "<c-]>",
      function()
        require("clasp").wrap("next")
      end,
      desc = "Jump to next region",
      mode = { "n", "i" },
    },
  },
}
