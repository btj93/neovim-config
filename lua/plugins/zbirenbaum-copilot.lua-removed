return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = { input = true, enabled = true, auto_trigger = true },
      filetypes = { ["*"] = true },
    })
  end,
}
