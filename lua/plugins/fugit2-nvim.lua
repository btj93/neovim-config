return {
  "SuperBo/fugit2.nvim",
  opts = {
    libgit2_path = "/opt/homebrew/lib/libgit2.dylib",
    show_patch = true,
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    {
      "chrisgrieser/nvim-tinygit", -- optional: for Github PR view
      dependencies = { "stevearc/dressing.nvim" },
    },
    "sindrets/diffview.nvim", -- optional: for Diffview
  },
  cmd = { "Fugit2", "Fugit2Graph" },
  keys = {
    { "<leader>F", mode = "n", "<cmd>Fugit2<cr>", desc = "Fugit2" },
  },
}
