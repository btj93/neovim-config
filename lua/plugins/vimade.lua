return {
  {
    "tadaa/vimade",
    opts = {
      -- Recipe can be any of 'default', 'minimalist', 'duo', and 'ripple'
      -- Set animate = true to enable animations on any recipe.
      -- See the docs for other config options.
      recipe = { "default", { animate = true } },
      tint = { bg = { rgb = { 0, 0, 0 }, intensity = 0.3 } },
      ncmode = "windows", -- use 'buffer' or 'windows'
      fadelevel = 0.6,
      blocklist = {
        default = {
          buf_opts = { buftype = { "prompt", "nofile", "terminal", "quickfix" } },
        },
      },
      focus = {
        providers = {
          filetypes = {
            markdown = {
              {
                "treesitter",
                {
                  min_node_size = 2,
                  min_size = 1,
                  max_size = 0,
                  include = {
                    "section",
                  },
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>uD",
        function()
          require("vimade.focus.api").toggle()
        end,
        desc = "toogle VimadeFocus",
      },
    },
  },
}
