return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function(_, opts)
    opts.formatters.sqlfluff = {
      args = { "format", "--dialect=mysql", "-" },
    }
    opts.format_on_save = {
      timeout_ms = 2500,
      lsp_fallback = true,
    }
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.cucumber = { "prettierd", "injected" }
    opts.formatters_by_ft.javascript = { "prettierd", "prettier" }

    -- Ensure Prettier only runs if a config exists or override the condition
    opts.formatters.prettier = {
      condition = function(ctx)
        return true -- Or use LazyVim's default: require("conform").get_formatter_config("prettier", ctx).has_config
      end,
    }

    opts.formatters.injected = {
      options = {
        ignore_errors = true, -- Proceed if formatting fails for one language
        lang_to_ext = {
          javascript = "js", -- Ensure JS regions are treated as .js for formatting
        },
        lang_to_formatters = {
          javascript = { "prettierd", "prettier", stop_after_first = true }, -- Explicitly use Prettier for JS regions
        },
      },
    }

    opts.formatters.reformat_gherkin = {
      command = "reformat-gherkin",
      args = { "-" },
      stdin = true,
    }

    return opts
  end,
}
