return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  dependencies = "rafamadriz/friendly-snippets",
  opts = {
    sources = {
      completion = {
        enabled_providers = { "ecolog", "lsp", "path", "snippets", "buffer" },
      },
      providers = {
        ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
      },
    },
  },
}
