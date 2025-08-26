return {
  "andythigpen/nvim-coverage",
  version = "*",
  config = function()
    require("coverage").setup({
      auto_reload = true,
    })
  end,
  keys = {
    {
      "<leader>tc",
      function()
        local coverage = require("coverage")
        local signs = require("coverage.signs")
        coverage.load(not signs.is_enabled())
      end,
      desc = "Toggle Test Coverage",
    },
    {
      "<leader>tS",
      function()
        if vim.bo.filetype == "coverage" then
          vim.cmd("quit")
        else
          local coverage = require("coverage")
          local signs = require("coverage.signs")
          coverage.load(signs.is_enabled())
          coverage.summary()
        end
      end,
      desc = "Toggle Test Coverage Summary",
      noremap = true,
    },
  },
}
