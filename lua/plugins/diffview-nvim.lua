return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- lazy, only load diffview by these commands
  cmd = {
    "DiffviewFileHistory",
    "DiffviewOpen",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
  },
  keys = {
    {
      "<leader>gf",
      function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd("DiffviewOpen")
        else
          vim.cmd("tabclose")
        end
      end,
      mode = "n",
      desc = "Diffview",
    },
  },
}
