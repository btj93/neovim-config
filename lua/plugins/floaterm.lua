return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  opts = {},
  cmd = "FloatermToggle",
  keys = {
    {
      "<leader>ft",
      function()
        require("floaterm").toggle()
      end,
      desc = "toggle floaterm",
      mode = { "n", "t" },
    },
  },
}
