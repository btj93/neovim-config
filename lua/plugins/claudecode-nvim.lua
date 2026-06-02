return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  opts = {
    -- Hide tmux from Claude. Claude runs inside nvim's :terminal but inherits
    -- $TMUX, so it wraps OSC 52 clipboard writes in tmux's DCS passthrough
    -- (ESC P tmux; ... ESC \). nvim isn't tmux, can't unwrap it, and renders
    -- the "52;c;<base64>" fragment on screen. Unsetting $TMUX/$TMUX_PANE makes
    -- Claude emit a plain OSC 52 (or use native clipboard), which nvim handles.
    terminal_cmd = "env -u TMUX -u TMUX_PANE claude",
    diff_opts = {
      layout = "vertical", -- "vertical" or "horizontal"
      open_in_new_tab = false,
      keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
      hide_terminal_in_new_tab = false,
      on_new_file_reject = "close_window", -- "keep_empty" or "close_window"

      -- Legacy aliases (still supported):
      -- vertical_split = true,
      -- open_in_current_tab = true,
    },
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>as", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
