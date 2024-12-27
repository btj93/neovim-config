-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "ruby", "html", "yaml", "javascript" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    require("todo-comments.search").search(function(results)
      if #results > 0 then
        vim.notify("You still have TODOs in your project!", vim.log.levels.WARN)
      end
    end, { disable_not_found_warnings = true })
  end,
})
