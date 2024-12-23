local function neotree_cwd()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end

local function neotree_root()
  require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "s1n7ax/nvim-window-picker",
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
  },
  keys = {
    {
      "<leader>fe",
      neotree_cwd,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>fE",
      neotree_root,
      desc = "Explorer NeoTree (Root Dir)",
    },
    { "<leader>e", neotree_cwd, desc = "Explorer NeoTree (cwd)" },
    { "<leader>E", neotree_root, desc = "Explorer NeoTree (Root Dir)" },
  },
}
