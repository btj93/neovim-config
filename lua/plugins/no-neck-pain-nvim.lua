return {
  "shortcuts/no-neck-pain.nvim",
  config = true,
  cmd = "NoNeckPain",
  keys = {
    { "<leader>un", "<cmd>NoNeckPain<cr>", desc = "Toggle No Neck Pain" },
  },
  opts = {
    autocmds = {
      -- When `true`, enables the plugin when you start Neovim.
      -- If the main window is  a side tree (e.g. NvimTree) or a dashboard, the command is delayed until it finds a valid window.
      -- The command is cleaned once it has successfuly ran once.
      -- When `safe`, debounces the plugin before enabling it.
      -- This is recommended if you:
      --  - use a dashboard plugin, or something that also triggers when Neovim is entered.
      --  - usually leverage commands such as `nvim +line file` which are executed after Neovim has been entered.
      ---@type boolean | "safe"
      enableOnVimEnter = true,
      -- When `true`, enables the plugin when you enter a new Tab.
      -- note: it does not trigger if you come back to an existing tab, to prevent unwanted interfer with user's decisions.
      ---@type boolean
      enableOnTabEnter = false,
      -- When `true`, reloads the plugin configuration after a colorscheme change.
      ---@type boolean
      reloadOnColorSchemeChange = false,
      -- When `true`, entering one of no-neck-pain side buffer will automatically skip it and go to the next available buffer.
      ---@type boolean
      skipEnteringNoNeckPainBuffer = false,
    },
    -- Creates mappings for you to easily interact with the exposed commands.
    ---@type table
    mappings = {
      -- When `true`, creates all the mappings that are not set to `false`.
      ---@type boolean
      enabled = false,
      -- Sets a global mapping to Neovim, which allows you to toggle the plugin.
      -- When `false`, the mapping is not created.
      ---@type string
      toggle = "<Leader>uN",
      -- Sets a global mapping to Neovim, which allows you to toggle the left side buffer.
      -- When `false`, the mapping is not created.
      ---@type string
      toggleLeftSide = false,
      -- Sets a global mapping to Neovim, which allows you to toggle the right side buffer.
      -- When `false`, the mapping is not created.
      ---@type string
      toggleRightSide = false,
      -- Sets a global mapping to Neovim, which allows you to increase the width (+5) of the main window.
      -- When `false`, the mapping is not created.
      ---@type string | { mapping: string, value: number }
      widthUp = false,
      -- Sets a global mapping to Neovim, which allows you to decrease the width (-5) of the main window.
      -- When `false`, the mapping is not created.
      ---@type string | { mapping: string, value: number }
      widthDown = false,
      -- Sets a global mapping to Neovim, which allows you to toggle the scratchPad feature.
      -- When `false`, the mapping is not created.
      ---@type string
      scratchPad = false,
    },
    ---@type table
    integrations = {
      -- @link https://github.com/nvim-tree/nvim-tree.lua
      ---@type table
      NvimTree = {
        -- The position of the tree.
        ---@type "left"|"right"
        position = "left",
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        ---@type boolean
        reopen = true,
      },
      -- @link https://github.com/nvim-neo-tree/neo-tree.nvim
      NeoTree = {
        -- The position of the tree.
        ---@type "left"|"right"
        position = "left",
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        reopen = true,
      },
      -- @link https://github.com/mbbill/undotree
      undotree = {
        -- The position of the tree.
        ---@type "left"|"right"
        position = "left",
      },
      -- @link https://github.com/nvim-neotest/neotest
      neotest = {
        -- The position of the tree.
        ---@type "right"
        position = "right",
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        reopen = true,
      },
      -- @link https://github.com/nvim-treesitter/playground
      TSPlayground = {
        -- The position of the tree.
        ---@type "right"|"left"
        position = "right",
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        reopen = true,
      },
      -- @link https://github.com/rcarriga/nvim-dap-ui
      NvimDAPUI = {
        -- The position of the tree.
        ---@type "none"
        position = "none",
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        reopen = true,
      },
      -- @link https://github.com/hedyhli/outline.nvim
      outline = {
        -- The position of the tree.
        ---@type "left"|"right"
        position = "right",
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        reopen = true,
      },
      -- @link https://github.com/stevearc/aerial.nvim
      aerial = {
        -- The position of the tree.
        ---@type "left"|"right"
        position = "right",
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        reopen = true,
      },
      -- this is a generic field to hint no-neck-pain that you use a dashboard plugin.
      -- you can find the filetype list of natively supported dashboards here: https://github.com/shortcuts/no-neck-pain.nvim/blob/main/lua/no-neck-pain/util/constants.lua#L82-L85
      -- if a dashboard that you use isn't supported, either set `dashboard.filetype` to the expected file type, or open a pull-request with the edited list.
      dashboard = {
        -- When `true`, debounce will be applied to the init method, leaving time for the dashboard to open.
        enabled = true,
        -- if a dashboard that you use isn't supported, you can use this field to set a matching filetype, also don't hesitate to open a pull-request with the edited list (DASHBOARDS) found in lua/no-neck-pain/util/constants.lua.
        ---@type string[]|nil
        filetypes = nil,
      },
    },
  },
}
