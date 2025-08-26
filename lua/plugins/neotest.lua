return {
  "nvim-neotest/neotest",
  dependencies = {
    { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
  },
  config = function()
    local neotest_golang_opts = {
      testify_enabled = true,
    } -- Specify custom configuration
    require("neotest").setup({
      adapters = {
        require("neotest-golang")(neotest_golang_opts), -- Registration
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
