return {
  "bassamsdata/namu.nvim",
  opts = {
    -- Enable the modules you want
    namu_symbols = {
      enable = true,
      options = {
        window = {
          auto_size = true,
          min_height = 1,
          min_width = 50,
          max_width = 800,
          max_height = 30,
          padding = 2,
          border = "rounded",
          title_pos = "left",
          show_footer = true,
          footer_pos = "right",
          relative = "editor",
          style = "minimal",
          width_ratio = 0.6,
          height_ratio = 0.6,
          title_prefix = "󱠦 ",
        },
      }, -- here you can configure namu
    },
    -- Optional: Enable other modules if needed
    colorscheme = {
      enable = false,
      options = {
        -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
        persist = true, -- very efficient mechanism to Remember selected colorscheme
        write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
      },
    },
    ui_select = { enable = false }, -- vim.ui.select() wrapper
  },
  keys = {
    {
      "<leader>o",
      function()
        require("namu.namu_symbols").show()
      end,
      { noremap = true, mode = "n", desc = "Jump to LSP symbol" },
    },
  },
}
