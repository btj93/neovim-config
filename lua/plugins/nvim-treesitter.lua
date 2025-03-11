return {
  "nvim-treesitter/nvim-treesitter",
  init = function()
    -- https://github.com/ravsii/tree-sitter-d2
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.d2 = {
      install_info = {
        url = "https://github.com/ravsii/tree-sitter-d2",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "d2",
    }

    -- we also need to tell neovim to use "d2" filetype on "*.d2" files, as well as
    -- token comment.
    -- ftplugin/autocmd is also an option.
    vim.filetype.add({
      extension = {
        d2 = function()
          return "d2", function(bufnr)
            vim.bo[bufnr].commentstring = "# %s"
          end
        end,
      },
    })
  end,
}
