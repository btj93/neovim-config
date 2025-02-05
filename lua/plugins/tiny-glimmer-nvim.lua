return {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  opts = {
    enabled = true,
    default_animation = "fade",
    overwrite = {
      -- Automatically map keys to overwrite operations
      -- If set to false, you will need to call the API functions to trigger the animations
      auto_map = true,

      search = {
        enabled = true,
        default_animation = "pulse",
        next_mapping = "nzzzv",
        prev_mapping = "Nzzzv",
      },
      paste = {
        enabled = true,
        default_animation = "custom",
      },
    },
    animations = {
      fade = {
        max_duration = 300,
        min_duration = 300,
        to_color = "#2d4f67",
        from_color = "#2d4f67",
      },
      pulse = {
        max_duration = 600,
        min_duration = 400,
        chars_for_max_duration = 15,
        pulse_count = 3,
        intensity = 1.5,
        to_color = "#ff9966",
        from_color = "#ff9966",
      },
      custom = {
        -- You can also add as many custom options as you want
        -- Only `max_duration` and `chars_for_max_duration` is required
        max_duration = 300,
        min_duration = 300,
        chars_for_max_duration = 1,

        color = "#40531b",

        -- Custom effect function
        -- @param self table The effect object
        -- @param progress number The progress of the animation [0, 1]
        --
        -- Should return a color and a progress value
        -- that represents how much of the animation should be drawn
        -- self.settings represents the settings of the animation that you defined above
        effect = function(self, progress)
          local utils = require("tiny-glimmer.utils")
          local easing_functions = require("tiny-glimmer.animation.easing")

          local from_color = "#000000"
          local to_color = self.settings.color

          local initial = utils.hex_to_rgb(from_color)
          local final = utils.hex_to_rgb(to_color)
          local current = {}

          local ease = "outQuad"

          local fn = easing_functions[ease]

          current = {
            r = utils.clamp(fn(progress, initial.r, final.r - initial.r, 1), 0, 255),
            g = utils.clamp(fn(progress, initial.g, final.g - initial.g, 1), 0, 255),
            b = utils.clamp(fn(progress, initial.b, final.b - initial.b, 1), 0, 255),
          }

          return utils.rgb_to_hex(current), progress
        end,
      },
    },
  },
  keys = {
    {
      "n",
      function()
        require("tiny-glimmer").search_next()
        vim.api.nvim_feedkeys("zzzv", "n", false)
      end,
      { noremap = true, silent = true },
    },
    {
      "N",
      function()
        require("tiny-glimmer").search_prev()
        vim.api.nvim_feedkeys("zzzv", "n", false)
      end,
      { noremap = true, silent = true },
    },
    {
      "*",
      function()
        require("tiny-glimmer").search_under_cursor()
        vim.api.nvim_feedkeys("zzzv", "n", false)
      end,
      { noremap = true, silent = true },
    },
  },
}
