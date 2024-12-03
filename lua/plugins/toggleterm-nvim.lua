return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "n",
        "<c-c>",
        "<cmd>lua vim.api.nvim_buf_delete(" .. term.bufnr .. ", { force = true })<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
}
