return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("bamboo").setup({
      highlights = {
        CursorLineNr = { fg = "$orange" },
      },
      -- optional configuration here
    })
    require("bamboo").load()
  end,
}
