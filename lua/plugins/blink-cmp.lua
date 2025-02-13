return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  dependencies = "rafamadriz/friendly-snippets",
  config = function(_, opts)
    opts.completion.menu.draw = {
      -- We don't need label_description now because label and label_description are already
      -- conbined together in label by colorful-menu.nvim.
      columns = { { "kind_icon" }, { "label", gap = 1 } },
      components = {
        label = {
          text = require("colorful-menu").blink_components_text,
          highlight = require("colorful-menu").blink_components_highlight,
        },
      },
    }
    opts.sources.compat = nil
    require("blink.cmp").setup(opts)
  end,
  opts = {
    enabled = function()
      return vim.bo.buftype ~= "prompt"
        and vim.b.completion ~= false
        and vim.bo.filetype ~= "DressingInput"
        and vim.bo.filetype ~= "dropbar_menu_fzf"
        and vim.bo.filetype ~= "minifiles"
    end,
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
      ["<Left>"] = { "fallback" },
      ["<Right>"] = { "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Esc>"] = { "hide", "fallback" },
      ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
      ["<PageDn>"] = { "scroll_documentation_down", "fallback" },
    },
  },
  opts_extend = { "sources.default" },
}
