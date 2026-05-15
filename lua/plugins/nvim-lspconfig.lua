return {
  "neovim/nvim-lspconfig",
  setup = function()
    vim.lsp.config.gopls.root_markers = { "go.work", "go.mod", ".git" }
    require("lspconfig").sourcekit.setup({
      cmd = { "sourcekit-lsp" },
      filetypes = { "swift" },
      root_markers = {
        ".git",
        "compile_commands.json",
        ".sourcekit-lsp",
        "Package.swift",
      },
      get_language_id = function(_, ftype)
        return ftype
      end,
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
        textDocument = {
          diagnostic = {
            dynamicRegistration = true,
            relatedDocumentSupport = true,
          },
        },
      },
    })
    vim.lsp.enable({ "gopls", "sourcekit" })
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
