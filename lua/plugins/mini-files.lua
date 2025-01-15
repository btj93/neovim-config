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
        MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
        -- defering to give time for git status to show
        vim.defer_fn(function()
          MiniFiles.reveal_cwd()
        end, 20)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
  },
}
