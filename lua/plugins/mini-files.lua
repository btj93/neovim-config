return {
  "echasnovski/mini.files",
  opts = {
    windows = {
      preview = true,
      width_focus = 40,
      width_preview = 40,
    },
  },
  keys = {
    {
      "<leader>fm",
      false,
    },
    {
      "<leader>fM",
      false,
    },
    {
      "-",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
  },
}
