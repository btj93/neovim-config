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
        default_animation = "fade",
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
        pulse_count = 2,
        intensity = 1.5,
      },
    },
  },
}
