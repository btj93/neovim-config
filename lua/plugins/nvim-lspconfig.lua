return {
  "neovim/nvim-lspconfig",
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- change a keymap
    keys[#keys + 1] = { "K", false }
    keys[#keys + 1] = { "m", vim.lsp.buf.hover }
  end,
}
