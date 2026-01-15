return {
  "serhez/bento.nvim",
  event = "VeryLazy",
  opts = {
    main_keymap = "`",
    ui = {
      mode = "floating", -- "floating" | "tabline"
      position = "middle-right", -- See position options below
      floating = {
        offset_x = 0, -- Horizontal offset from position
        offset_y = 0, -- Vertical offset from position
        dash_char = "─", -- Character for collapsed dashes
        label_padding = 1, -- Padding around labels
        minimal_menu = "dashed", -- nil | "dashed" | "filename" | "full"
        max_rendered_buffers = 4, -- nil (no limit) or number for pagination
      },
    },
  },
}
