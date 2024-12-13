return {
  "philosofonusus/ecolog.nvim",
  config = function()
    require("ecolog").setup({
      integrations = {
        lsp = true, -- Enables LSP support
      },
      path = vim.fn.getcwd(), -- Path to search for .env files
      preferred_environment = "development", -- Optional: prioritize specific env files
    })
    require("telescope").load_extension("ecolog")
  end,
  dependencies = {
    "hrsh7th/nvim-cmp", -- Optional, for autocompletion support
  },
  -- Optionally reccommend adding keybinds (lsp integration supposed to handle some of them automatically so please check it out)
  keys = {
    -- { "<leader>ge", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
    { "<leader>ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
    --   { "<leader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
  },
  lazy = false,
}
