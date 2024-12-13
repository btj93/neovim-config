return {
  "leath-dub/snipe.nvim",
  opts = {
    ui = {
      preselect_current = true,
      open_win_override = {
        border = "rounded", -- use "rounded" for rounded border
      },
      text_align = "file-first",
    },
    navigate = {
      cancel_snipe = { "q", "<esc>" },
    },
  },
  keys = {
    {
      "<leader>bs",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
}
