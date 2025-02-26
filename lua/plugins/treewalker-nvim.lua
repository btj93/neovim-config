return {
  "aaronik/treewalker.nvim",
  opts = {
    highlight = true, -- default is false
  },
  keys = {
    { "<S-j>", "<cmd>Treewalker Down<CR>", mode = { "n", "v" }, noremap = true },
    { "<S-k>", "<cmd>Treewalker Up<CR>", mode = { "n", "v" }, noremap = true },
    { "<S-h>", "<cmd>Treewalker Left<CR>", mode = { "n", "v" }, noremap = true },
    { "<S-l>", "<cmd>Treewalker Right<CR>", mode = { "n", "v" }, noremap = true },
  },
}
