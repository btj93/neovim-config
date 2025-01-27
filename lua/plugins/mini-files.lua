return {
  "echasnovski/mini.files",
  opts = {
    windows = {
      preview = true,
      width_focus = 40,
      width_preview = 40,
    },
    mappings = {
      synchronize = ":w",
      change_cwd = false,
      -- default mappings
      -- https://github.com/LazyVim/LazyVim/commit/393aa44e66f8496489221fd166ab32c3d834d9c6
      toggle_hidden = "g.",
      go_in_horizontal = "<c-s>",
      go_in_vertical = "<c-v>",
      go_in_horizontal_plus = "<c-S>",
      go_in_vertical_plus = "<c-V>",
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
        end, 10)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
  },
}
