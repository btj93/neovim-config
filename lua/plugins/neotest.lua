-- Helper function to get the current function or method name using Tree-sitter.
-- This function remains unchanged.
local function get_current_function_or_method_name()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local parser = vim.treesitter.get_parser(buf, "go")

  if not parser then
    return nil
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  local current_node = root:descendant_for_range(row - 1, col, row - 1, col)

  if not current_node then
    return nil
  end

  local containing_node = current_node
  while containing_node do
    local node_type = containing_node:type()
    if node_type == "method_declaration" or node_type == "function_declaration" then
      break
    end
    containing_node = containing_node:parent()
  end

  if containing_node then
    local query_str
    if containing_node:type() == "method_declaration" then
      query_str = [[(method_declaration name: (field_identifier) @name)]]
    else
      query_str = [[(function_declaration name: (identifier) @name)]]
    end

    local query = vim.treesitter.query.parse("go", query_str)
    for id, node in query:iter_captures(containing_node, buf) do
      if query.captures[id] == "name" then
        return vim.treesitter.get_node_text(node, buf)
      end
    end
  end

  return nil
end

-- Main function to build and send the Go test command to tmux.
function SendGoTestToTmux()
  local target_pane = "'neotest:1.1'"

  -- Check for and exit copy-mode in tmux
  local check_mode_cmd = string.format("tmux display-message -p -t %s '#{pane_in_mode}'", target_pane)
  local is_in_mode = vim.fn.system(check_mode_cmd)

  if is_in_mode == "1\n" then
    print("Tmux pane is in copy-mode. Sending C-c to exit...")
    local exit_mode_cmd = string.format("tmux send-keys -t %s C-c", target_pane)
    vim.fn.system(exit_mode_cmd)

    -- ===================================================================
    -- CORRECTED LINE: Use vim.loop.sleep() for a non-blocking delay
    -- ===================================================================
    vim.loop.sleep(50) -- sleep for 50 milliseconds
    -- ===================================================================
  end

  -- Get the current file's absolute path
  local current_file_path = vim.api.nvim_buf_get_name(0)
  if current_file_path == "" then
    print("Error: Buffer has no associated file name.")
    return
  end

  -- Get the absolute directory of the current file
  local file_directory = vim.fn.fnamemodify(current_file_path, ":h")
  if file_directory == "" or file_directory == "." then
    print("Error: Could not determine directory for the current file.")
    return
  end

  -- Get the current function/method name
  local test_name = get_current_function_or_method_name()
  if not test_name then
    print("Error: Could not find a Go test function/method at the cursor position.")
    return
  end

  -- Construct the command to run
  local command_to_run =
    string.format("(cd %s && go test -v -testify.m %s)", vim.fn.shellescape(file_directory), test_name)

  -- Build the full tmux command
  local tmux_command =
    string.format("tmux send-keys -t %s C-z %s Enter", target_pane, vim.fn.shellescape(command_to_run))

  -- Execute the command
  print("Sending go test command to tmux...")
  vim.fn.system(tmux_command)
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    {
      "fredrikaverpil/neotest-golang",
      version = "*", -- Optional, but recommended
      build = function()
        vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
      end,
    },
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local neotest_golang_opts = {
      testify_enabled = true,
      runner = "gotestsum",
      -- log_level = vim.log.levels.TRACE,
    }
    require("neotest").setup({
      adapters = {
        require("neotest-golang")(neotest_golang_opts),
      },
    })
  end,
  keys = {
    { "<leader>tS", false },
    {
      "<leader>tt",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File (Neotest)",
    },
    {
      "<leader>tT",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files (Neotest)",
    },
    {
      "<leader>tm",
      SendGoTestToTmux,
      desc = "Run Nearest (Neotest)",
    },
    {
      "<leader>tr",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run()
      end,
      desc = "Run Nearest (Neotest)",
    },
    {
      "<leader>tl",
      function()
        require("neotest").output_panel.clear()
        require("neotest").run.run_last()
      end,
      desc = "Run Last (Neotest)",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true, last_run = true })
      end,
      desc = "Show Output (Neotest)",
    },
  },
}
