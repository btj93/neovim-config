return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  config = function()
    require("bqf").setup({
      auto_enable = true,
      func_map = {
        vsplit = "",
      },
    })
  end,
}
