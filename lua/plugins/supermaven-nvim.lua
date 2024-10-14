return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<M-l>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-l>",
      },
    })
  end,
}
