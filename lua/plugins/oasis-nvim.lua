return {
  "uhs-robert/oasis.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("oasis").setup({
      style = "desert",
    }) -- (see Configuration below for all customization options)
    vim.cmd.colorscheme("oasis") -- After setup, apply theme (or any style like "oasis-night")
  end,
}
