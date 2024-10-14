return {
  "mistricky/codesnap.nvim",
  build = "make",
  keys = {
    { "cc", "<Esc><cmd>CodeSnap<cr>", mode = "v", desc = "Code snap to clipboard" },
    { "cs", "<Esc><cmd>CodeSnapSave<cr>", mode = "v", desc = "Code snap to file" },
    { "ch", "<Esc><cmd>CodeSnapHighlight<cr>", mode = "v", desc = "Code snap highlight" },
  },
  opts = {
    save_path = "~/Downloads",
    has_breadcrumbs = true,
    has_line_number = true,
  },
}
