return {
  "mistricky/codesnap.nvim",
  tag = "v2.0.0-beta.17",
  cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight" },
  keys = {
    { "cc", "<Esc><cmd>CodeSnap<cr>", mode = "v", desc = "Code snap to clipboard" },
    { "cs", "<Esc><cmd>CodeSnapSave<cr>", mode = "v", desc = "Code snap to file" },
    { "ch", "<Esc><cmd>CodeSnapHighlight<cr>", mode = "v", desc = "Code snap highlight" },
  },
  opts = {},
}
