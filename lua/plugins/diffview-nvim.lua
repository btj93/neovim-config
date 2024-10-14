return {
  "sindrets/diffview.nvim",
  config = function()
    -- vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "Open DiffView File History" })
    -- vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open DiffView" })
    local actions = require("diffview.actions")

    require("diffview").setup({
      -- Your setup opts here (leave empty to use defaults)
      keymaps = {
        view = {
          { "n", "q", actions.close, { desc = "Close the panel" } },
          { "n", "co", actions.conflict_choose_all("ours"), { desc = "Choose conflict --ours" } },
          { "n", "ct", actions.conflict_choose_all("theirs"), { desc = "Choose conflict --theirs" } },
          { "n", "cb", actions.conflict_choose_all("base"), { desc = "Choose conflict --base" } },
        },
        file_panel = {},
      },
    })
  end,
}
