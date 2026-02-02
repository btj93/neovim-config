return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.parsers").gherkin = {
        install_info = {
          url = "https://github.com/binhtran432k/tree-sitter-gherkin",
          branch = "main", -- only needed if different from default branch
          queries = "queries/gherkin", -- also install queries from given directory
        },
      }

      vim.treesitter.language.register("gherkin", { "feature", "cucumber" })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "cucumber", "go", "gomod", "javascript", "typescript", "lua", "bash", "markdown" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
    opts = function(_, opts)
      -- Register the Gherkin language for .feature files
      -- vim.treesitter.language.register("gherkin", "cucumber")
      -- local parsers = require("nvim-treesitter.parsers")
      -- parsers.gherkin = {
      --   install_info = {
      --     url = "https://github.com/binhtran432k/tree-sitter-gherkin",
      --     branch = "main",
      --     revision = "1a709ae",
      --     path = { "src/parser.c", "src/scanner.c" },
      --   },
      --   tier = 2,
      --   filetype = "feature",
      -- }

      -- local gherkin_opts = {
      --   highlight = {
      --     enable = { "gherkin" },
      --
      --     additional_vim_regex_highlighting = false,
      --   },
      -- }
      --
      -- opts = vim.tbl_deep_extend("force", opts, gherkin_opts)

      return opts
    end,
  },
}
