return {
  "mfussenegger/nvim-lint",
  init = function()
    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = require("lint").linters_by_ft[filetype]

      if linters then
        print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
      else
        print("No linters configured for filetype: " .. filetype)
      end
    end, {})

    local lint = require("lint")

    lint.linters_by_ft = {
      go = { "golangcilint" },
      terraform = { "tflint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>lb", function()
      local golang = lint.linters.golangcilint
      local args = golang.args
      local final_args = {}
      for _, v in ipairs(args) do
        if type(v) == "function" then
          table.insert(final_args, v())
        else
          table.insert(final_args, v)
        end
      end

      print("nvim-lint would run:")
      print("golangci-lint " .. table.concat(final_args, " "))
      lint.try_lint()
    end, { desc = "Trigger linting (with debug)" })
  end,
  opts = {
    linters_by_ft = {
      go = { "golangcilint" },
    },
    linters = {
      golangcilint = {
        cmd = "golangci-lint",
        args = {
          "run",
          "--output.json.path=stdout",
          -- Overwrite values possibly set in .golangci.yml
          "--output.text.path=",
          "--output.tab.path=",
          "--output.html.path=",
          "--output.checkstyle.path=",
          "--output.code-climate.path=",
          "--output.junit-xml.path=",
          "--output.teamcity.path=",
          "--output.sarif.path=",
          "--issues-exit-code=0",
          "--show-stats=false",
          -- Get absolute path of the linted file
          "--path-mode=abs",
          function()
            local util = require("lspconfig.util")
            local current_file = vim.api.nvim_buf_get_name(0)

            -- Find the directory containing the nearest go.mod
            local gomod_dir = util.root_pattern("go.mod")(current_file)
            return gomod_dir .. "/..."
            -- return vim.fn.getcwd() .. "/..."
          end,
        },
        stream = "both",
        -- Add a pattern to parse the JSON output (nvim-lint has a built-in JSON parser for linters)
        -- You might need to check the nvim-lint documentation for the exact parser name if default fails.
      },
      sqlfluff = {
        args = {
          "lint",
          "--format=json",
          -- note: users will have to replace the --dialect argument accordingly
          "--dialect=mysql",
        },
      },
    },
  },
}
