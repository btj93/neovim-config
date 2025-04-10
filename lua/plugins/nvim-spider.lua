local ft = { "go", "python", "java", "lua" }

return {
  "chrisgrieser/nvim-spider",
  keys = {
    -- For dot-repeat to work, you have to call the motions as Ex-commands.
    { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "v", "o", "x" }, ft = ft },
    { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "v", "o", "x" }, ft = ft },
    { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "v", "o", "x" }, ft = ft },
  },
}
