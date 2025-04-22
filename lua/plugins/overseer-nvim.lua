function Load_env_vars()
  local env_vars = {}
  local env_file = ".env"
  local file = io.open(env_file, "r")
  if file then
    for line in file:lines() do
      local key, value = line:match("^(%S+)%s*=%s*(.+)$")
      if key and value then
        env_vars[key] = value
      end
    end
    file:close()
  end
  return env_vars
end

return {
  "stevearc/overseer.nvim",
  config = true,
  opts = {
    strategy = {
      "toggleterm",
      direction = "vertical",
      size = 50,
    },
    templates = { "builtin", "go", "d2" },
    task_list = {
      bindings = {
        ["?"] = "ShowHelp",
        ["g?"] = "ShowHelp",
        ["<CR>"] = "RunAction",
        ["<C-e>"] = "Edit",
        ["o"] = "Open",
        ["<C-v>"] = "OpenVsplit",
        ["<C-s>"] = "OpenSplit",
        ["<C-f>"] = "OpenFloat",
        ["<C-q>"] = "OpenQuickFix",
        ["p"] = "TogglePreview",
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["L"] = "IncreaseDetail",
        ["H"] = "DecreaseDetail",
        ["["] = "DecreaseWidth",
        ["]"] = "IncreaseWidth",
        ["{"] = "PrevTask",
        ["}"] = "NextTask",
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["K"] = "ScrollOutputUp",
        ["J"] = "ScrollOutputDown",
        ["q"] = "Close",
      },
    },
  },
  keys = {
    { "<leader>p", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
    { "<leader>;", "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" },
  },
}
