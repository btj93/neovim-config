return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- use vim.diagnostic.config virtual_lines from neovim 0.11
    opts.diagnostics.virtual_text = false
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- change a keymap
    keys[#keys + 1] = { "K", false }
    keys[#keys + 1] = { "<leader>ca", false }
    keys[#keys + 1] = { "m", vim.lsp.buf.hover }
    return opts
  end,
}
