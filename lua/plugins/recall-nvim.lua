return {
  "fnune/recall.nvim",
  version = "*",
  config = function()
    local recall = require("recall")

    recall.setup({})
  end,
  keys = {
    { "<leader>mm", "<cmd>RecallToggle<CR>", mode = "n", desc = "Toggle Recall" },
    { "<leader>ml", "<cmd>Telescope recall<CR>", mode = "n", desc = "Recall" },
  },
}
