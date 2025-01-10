return {
  "fnune/recall.nvim",
  version = "*",
  config = true,
  keys = {
    { "<leader>mm", "<cmd>RecallToggle<CR>", mode = "n", desc = "Toggle Recall" },
    { "<leader>ml", "<cmd>Telescope recall<CR>", mode = "n", desc = "Recall" },
  },
}
