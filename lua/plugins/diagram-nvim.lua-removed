return {
  "3rd/diagram.nvim",
  dependencies = {
    "3rd/image.nvim",
  },
  config = function()
    require("image").setup({})
    require("diagram").setup({
      integrations = {
        require("diagram.integrations.markdown"),
        require("diagram.integrations.neorg"),
      },
      renderer_options = {
        mermaid = {
          background = nil, -- nil | "transparent" | "white" | "#hex"
          theme = nil, -- nil | "default" | "dark" | "forest" | "neutral"
          scale = 3, -- nil | 1 (default) | 2  | 3 | ...
          width = 800, -- nil | 800 | 400 | ...
          height = 800, -- nil | 600 | 300 | ...
        },
        plantuml = {
          charset = nil,
        },
        d2 = {
          theme_id = nil,
          dark_theme_id = nil,
          scale = nil,
          layout = nil,
          sketch = nil,
        },
      },
    })
  end,
}
