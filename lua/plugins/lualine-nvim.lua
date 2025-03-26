return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- reference: https://github.com/rachartier/dotfiles/blob/main/.config%2Fnvim%2Flua%2Fplugins%2Fui%2Flualine.lua#L159
    local kirby_default = "(>*-*)>"
    local mode_kirby = {
      n = "<(•ᴗ•)>",
      i = "<(•o•)>",
      v = "(v•-•)v",
      [""] = "(v•-•)>",
      V = "(>•-•)>",
      c = kirby_default,
      no = "<(•ᴗ•)>",
      s = kirby_default,
      S = kirby_default,
      [""] = kirby_default,
      ic = kirby_default,
      R = kirby_default,
      Rv = kirby_default,
      cv = "<(•ᴗ•)>",
      ce = "<(•ᴗ•)>",
      r = kirby_default,
      rm = kirby_default,
      ["r?"] = kirby_default,
      ["!"] = "<(•ᴗ•)>",
      t = "<(•ᴗ•)>",
    }
    opts.sections.lualine_a = {
      {
        "mode",
        -- icons_enabled = true,
        fmt = function()
          return mode_kirby[vim.fn.mode()] or vim.api.nvim_get_mode().mode
        end,
        padding = { left = 1, right = 1 },
      },
    }

    local icons = LazyVim.config.icons
    opts.sections.lualine_b = {
      LazyVim.lualine.root_dir(),
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype" },
      {
        function()
          local msg = " No Active Lsp"
          local text_clients = ""

          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            if client.name ~= "copilot" then
              text_clients = text_clients .. client.name .. ", "
            end
          end
          if text_clients ~= "" then
            return text_clients:sub(1, -3)
          end
          return msg
        end,
        icon = "",
      },
    }
    opts.sections.lualine_c = {
      "%=",
      { require("harpoon_files").lualine_component, separator = { left = "<", right = ">" } },
    }
  end,
}
