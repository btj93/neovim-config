return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  },
}
