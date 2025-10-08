return {
  "nvim-neotest/neotest",
  dependencies = {
    {
      "fredrikaverpil/neotest-golang",
      version = "*", -- Optional, but recommended
      build = function()
        vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
      end,
    },
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local neotest_golang_opts = {
      testify_enabled = true,
      runner = "gotestsum",
      -- log_level = vim.log.levels.TRACE,
    }
    require("neotest").setup({
      adapters = {
        require("neotest-golang")(neotest_golang_opts),
      },
    })
  end,
  keys = {
    { "<leader>tS", false },
    {
      "<leader>tt",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File (Neotest)",
    },
    {
      "<leader>tT",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files (Neotest)",
    },
    {
      "<leader>tr",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run()
      end,
      desc = "Run Nearest (Neotest)",
    },
    {
      "<leader>tl",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run_last()
      end,
      desc = "Run Last (Neotest)",
    },
  },
}
