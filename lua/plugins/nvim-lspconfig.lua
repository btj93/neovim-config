return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", has = "definition" },
          { "K", false },
          { "<leader>ca", false }, -- use tiny-code-actions
          { "m", vim.lsp.buf.hover },
        },
      },
    },
  },
}
