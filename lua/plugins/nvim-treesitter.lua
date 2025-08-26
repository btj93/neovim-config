return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(_, opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.gherkin = {
        install_info = {
          url = "https://github.com/binhtran432k/tree-sitter-gherkin",
          branch = "main",
          files = { "src/parser.c", "src/scanner.c" },
        },
        filetype = "feature",
      }
    end,
    opts = function(_, opts)
      -- Register the Gherkin language for .feature files
      vim.treesitter.language.register("gherkin", "cucumber")

      return opts
    end,
  },
}
