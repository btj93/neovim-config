return {
  "ibhagwan/fzf-lua",
  opts = {
    files = {
      rg_opts = [[--color=never --files --hidden --follow --no-ignore]],
      fd_opts = [[--color=never --type f --hidden --follow --no-ignore]],
      formatter = "path.filename_first",
    },
    grep = {
      grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e --hidden",
      rg_opts = "--column --line-number --no-heading --color=always --smart-case  --hidden --no-ignore --max-columns=4096 -e",
      rg_glob = true,
    },
  },
  keys = {
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (CWD)" },
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (CWD)" },
  },
}
