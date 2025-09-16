return {
  "danymat/neogen",
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate()
      end,
      desc = "Neogen",
    },
  },
}
