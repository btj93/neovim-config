return {
  "zbirenbaum/copilot.lua",
  dependencies = {
    -- "copilotlsp-nvim/copilot-lsp",
    -- init = function()
    --   vim.g.copilot_nes_debounce = 500
    -- end,
  },
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false,
        auto_refresh = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 10,
        trigger_on_accept = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<C-l>",
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-}>",
        },
      },
      -- nes = {
      --   enabled = true,
      --   keymap = {
      --     accept_and_goto = "<leader>p",
      --     accept = false,
      --     dismiss = "<Esc>",
      --   },
      -- },
    })
  end,
}
