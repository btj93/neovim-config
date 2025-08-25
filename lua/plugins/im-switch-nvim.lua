return {
  "chojs23/im-switch.nvim",
  build = "make build",
  config = function()
    require("im-switch").setup({
      -- Configuration options (see below)
    })
  end,
  event = "VeryLazy",
}
