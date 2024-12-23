return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  dependencies = "rafamadriz/friendly-snippets",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { "ecolog" },
      providers = {
        ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
      },
    },
    keymap = {
      preset = "default",
      ["<Down>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_forward()
          else
            return cmp.select_next()
          end
        end,
        "select_next",
        "fallback",
      },
      ["<Up>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return cmp.select_prev()
          end
        end,
        "select_prev",
        "fallback",
      },
      ["<CR>"] = { "accept", "fallback" },
      ["<Esc>"] = { "hide", "fallback" },
      ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
      ["<PageDn>"] = { "scroll_documentation_down", "fallback" },
    },
  },
  opts_extend = { "sources.default" },
}
