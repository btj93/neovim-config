return {
  "Bekaboo/dropbar.nvim",
  -- optional, but required for fuzzy finder support
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  config = function()
    local dropbar_api = require("dropbar.api")
    local utils = require("dropbar.utils")
    vim.keymap.set("n", "-", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    -- vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    -- vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    require("dropbar").setup({
      bar = {
        pick = {
          pivots = "qwertyuiop",
        },
      },
      menu = {
        keymaps = {
          ["h"] = "<C-w>q",
          ["/"] = function()
            local menu = utils.menu.get_current()
            if not menu then
              return
            end
            menu:fuzzy_find_open()
          end,
          ["l"] = function()
            local menu = utils.menu.get_current()
            if not menu then
              return
            end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if component then
              menu:click_on(component, nil, 1, "l")
            end
          end,
        },
      },
    })
  end,
}
