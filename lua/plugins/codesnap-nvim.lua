return {
  "mistricky/codesnap.nvim",
  tag = "v2.0.0-beta.17",
  cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight" },
  keys = {
    { "<leader>cc", "<Esc><cmd>CodeSnap<cr>", mode = "v", desc = "Code snap to clipboard" },
    { "<leader>cs", "<Esc><cmd>CodeSnapSave<cr>", mode = "v", desc = "Code snap to file" },
    { "<leader>ch", "<Esc><cmd>CodeSnapHighlight<cr>", mode = "v", desc = "Code snap highlight" },
  },
  opts = {},
}
