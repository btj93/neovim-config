return {
  "leath-dub/snipe.nvim",
  opts = {
    ui = {
      preselect_current = true,
      open_win_override = {
        border = "rounded", -- use "rounded" for rounded border
      },
      position = "cursor",
      text_align = "file-first",
    },
    navigate = {
      cancel_snipe = { "q", "<esc>" },
    },
    sort = "last",
  },
  keys = {
    {
      "<leader>a",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
}
