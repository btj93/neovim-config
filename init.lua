-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.termguicolors = true

-- bufferline config --
-- require("bufferline").setup({
--   options = {
--     hover = {
--       enabled = true,
--       delay = 150,
--       reveal = { "close" },
--     },
--     separator_style = "slant",
--   },
-- })
--
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
