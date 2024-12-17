return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (CWD)" },
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (CWD)" },
  },
}
