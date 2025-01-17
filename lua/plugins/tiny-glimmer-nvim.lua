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
      },
      paste = {
        enabled = true,
        default_animation = "fade",
      },
    },
    animations = {
      fade = {
        max_duration = 200,
        min_duration = 200,
        -- easing = "linear",
        -- to_color = "#e2c792",
        to_color = "#2d4f67",
      },
    },
  },
}
