return {
  "mvllow/modes.nvim",
  tag = "v0.2.1",
  config = function()
    require("modes").setup({
      colors = {
        visual = "#8fb573",
      },
    })
  end,
}
