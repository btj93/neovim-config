return {
  "samiulsami/fFtT-highlights.nvim",
  config = function()
    ---@module "fFtT-highlights"
    ---@type fFtT_highlights.opts
    require("fFtT-highlights"):setup({
      ---See below for default configuration options
      smart_motions = false,
      multi_line = {
        enable = true,
        max_lines = 300,
      },
      jumpable_chars = {
        -- options: "always" | "on_key_press" | "never"
        show_instantly_jumpable = "on_key_press", -- when to highlight characters that can be jumped to in 1 step (options below have no effect when this is disabled).
        show_secondary_jumpable = "never", -- when to highlight characters that can be jumped to in 2 steps.
        show_all_jumpable_in_words = "on_key_press", -- when to highlight all jumpable characters in a word.
        show_multiline_jumpable = "on_key_press", -- when to highlight jumpable characters in other lines.
        min_gap = 1, -- minimum gap between two jumpable characters.
        priority = 1100, -- jumpable chars highlight priority.
        priority_secondary = 1000, -- secondary jumpable chars highlight priority.
      },
    })
  end,
}
