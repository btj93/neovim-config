return {
  "TheNoeTrevino/no-go.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = "go",
  opts = {
    -- Your configuration here (optional)
    -- lazy.nvim automatically calls setup() with the opts property
    identifiers = { "err", "error" }, -- Customize which identifiers to collapse
    -- look at the default config for more details
    highlight_group = "LspInlayHint",
    fold_imports = true,
  },
}
