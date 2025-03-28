-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spelllang = "en_us,cjk"
vim.opt.spell = true
vim.opt.scrolloff = 10
vim.opt.diffopt = "filler,internal,closeoff,context:5,linematch:60,algorithm:histogram"
vim.opt.fileencodings = "utf-8,sjis"
vim.opt.encoding = "utf-8"
vim.diagnostic.config({
  -- Use the default configuration
  virtual_lines = true,

  -- Alternatively, customize specific options
  -- virtual_lines = {
  --  -- Only show virtual line diagnostics for the current cursor line
  --  current_line = true,
  -- },
})
