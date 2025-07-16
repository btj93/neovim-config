return {
  "Owen-Dechow/nvim_json_graph_view",
  opts = {
    accept_all_files = false,
    -- Allow opening non .json files

    max_lines = 5,
    -- Number of lines before collapsing

    keymaps = {
      expand = "E", -- Expanding collapsed areas
      link_forward = "L", -- Jump to linked unit
      link_backward = "B", -- Jump back to unit parent
    },
  },
}
