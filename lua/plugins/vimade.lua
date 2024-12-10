return {
  {
    "tadaa/vimade",
    opts = {
      -- Recipe can be any of 'default', 'minimalist', 'duo', and 'ripple'
      -- Set animate = true to enable animations on any recipe.
      -- See the docs for other config options.
      recipe = { "default", { animate = true } },
      tint = { bg = { rgb = { 0, 0, 0 }, intensity = 0.3 } },
      ncmode = "windows", -- use 'buffer' or 'windows'
      fadelevel = 0.8,
    },
  },
}
