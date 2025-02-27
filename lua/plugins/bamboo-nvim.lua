return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("bamboo").setup({
      highlights = {
        Search = { bg = "$fg", fg = "$light_grey" },
      },
      -- optional configuration here
    })
    require("bamboo").load()
  end,
}
