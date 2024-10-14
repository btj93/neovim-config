-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.termguicolors = true
-- require("catppuccin").setup({
--   flavour = "frappe", -- latte, frappe, macchiato, mocha
-- })
-- vim.api.nvim_command([[colorscheme catppuccin-frappe]])
-- vim.api.nvim_command([[colorscheme nordfox]])
-- vim.api.nvim_command([[colorscheme kanagawa]])
-- vim.api.nvim_command([[colorscheme monokai]])
-- vim.api.nvim_command([[colorscheme forestbones]])
-- vim.api.nvim_command([[colorscheme zenburned]])
-- vim.api.nvim_command([[colorscheme panda]])
vim.api.nvim_command([[colorscheme bamboo]])
-- vim.api.nvim_command([[colorscheme cyberdream]])

-- bufferline config --
require("bufferline").setup({
  options = {
    hover = {
      enabled = true,
      delay = 150,
      reveal = { "close" },
    },
    separator_style = "slant",
  },
})

require("codesnap").setup({
  has_breadcrumbs = true,
})

require("flash").setup({
  modes = {
    search = {
      enabled = true,
    },
  },
})

require("quicker").setup()
require("encourage").setup()

-- require("copilot").setup({
--   suggestion = { enabled = true, auto_trigger = true },
--   filetypes = { ["*"] = true },
-- })
--
-- require("cmp").setup({
--   enabled = false,
-- })
