return {
  "nvim-mini/mini.ai",
  keys = {
    {
      "[f",
      function()
        require("mini.ai").move_cursor("left", "a", "f", { search_method = "prev" })
      end,
      { desc = "Previous function", mode = { "n", "x", "o" } },
    },
    {
      "]f",
      function()
        require("mini.ai").move_cursor("left", "a", "f", { search_method = "next" })
      end,
      { desc = "Next function", mode = { "n", "x", "o" } },
    },
  },
}
