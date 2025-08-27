return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Register the Gherkin language for .feature files
      vim.treesitter.language.register("gherkin", "cucumber")
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.gherkin = {
        install_info = {
          url = "https://github.com/binhtran432k/tree-sitter-gherkin",
          branch = "main",
          files = { "src/parser.c", "src/scanner.c" },
        },
        filetype = "feature",
      }

      local gherkin_opts = {
        highlight = {
          enable = { "gherkin" },

          additional_vim_regex_highlighting = false,
        },
      }

      opts = vim.tbl_deep_extend("force", opts, gherkin_opts)

      return opts
    end,
  },
}
