return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    require("fff.download").download_or_build_binary()
  end,
  -- or if you are using nixos
  -- build = "nix run .#release",
  opts = {
    title = "Freakin Fast Fuzzy File Finder",
    max_threads = 8,
    max_results = 50,
    lazy_sync = false,
    debug = {
      enabled = true, -- we expect your collaboration at least during the beta
      show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
    },
    layout = {
      prompt_position = "top",
    },
  },
  lazy = false,
  keys = {
    {
      "<leader><space>", -- try it if you didn't it is a banger keybinding for a picker
      function()
        require("fff").find_files() -- or find_in_git_root() if you only want git files
      end,
      desc = "Open file picker",
    },
  },
}
