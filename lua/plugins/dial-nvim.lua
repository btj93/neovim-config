return {
  "monaqa/dial.nvim",
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      -- default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.constant.alias.bool,
        augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
        augend.constant.new({
          elements = { "and", "or" },
          word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
          cyclic = true, -- "or" is incremented into "and".
        }),
        augend.constant.new({
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        }),
      },
    })
  end,
  keys = {
    {
      "<c-a>",
      function()
        require("dial.map").manipulate("increment", "normal")
      end,
      mode = "n",
    },
    {
      "<c-x>",
      function()
        require("dial.map").manipulate("decrement", "normal")
      end,
      mode = "n",
    },
    {
      "<c-a>",
      function()
        require("dial.map").manipulate("increment", "visual")
      end,
      mode = "v",
    },
    {
      "<c-x>",
      function()
        require("dial.map").manipulate("decrement", "visual")
      end,
      mode = "v",
    },
  },
}
