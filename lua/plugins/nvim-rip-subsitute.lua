return {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  opts = {
    popupWin = {
      position = "top", ---@type "top"|"bottom"
    },
  },
  keys = {
    {
      "<leader>r",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = " rip substitute",
    },
  },
}
