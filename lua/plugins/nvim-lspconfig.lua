return {
  "neovim/nvim-lspconfig",
  setup = function()
    vim.lsp.config.gopls.root_markers = { "go.work", "go.mod", ".git" }
    vim.lsp.enable({ "gopls" })
  end,
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = false,
    },
    servers = {
      ["*"] = {
        keys = {
          { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", has = "definition" },
          { "K", false },
          { "<leader>ca", false }, -- use tiny-code-actions
          {
            "m",
            function()
              vim.lsp.buf.hover({
                border = "single",
              })
            end,
          },
        },
      },
    },
  },
}
