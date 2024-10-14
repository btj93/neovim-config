-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n" }, "cfp", ':let @+ = expand("%")<CR>', { noremap = true, desc = "Copy file relative path" })
vim.keymap.set({ "n" }, "cfP", ':let @+ = expand("%:p")<CR>', { noremap = true, desc = "Copy file absolute path" })
vim.keymap.set({ "n" }, "cfn", ':let @+ = expand("%:t")<CR>', { noremap = true, desc = "Copy filename" })
vim.keymap.set({ "n", "v" }, "K", "5k", { noremap = true, desc = "Up faster" })
vim.keymap.set({ "n", "v" }, "J", "5j", { noremap = true, desc = "Down faster" })
vim.keymap.set({ "n" }, "<leader><leader>", "<cmd>Telescope find_files<cr>", { noremap = true, desc = "Find files" })
vim.keymap.set({ "n" }, "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, desc = "Find files" })
vim.keymap.set({ "n" }, "<Tab>", ">>_", { noremap = true, desc = "Add indent" })
vim.keymap.set({ "n" }, "<S-Tab>", "<<_", { noremap = true, desc = "Remove indent" })
vim.keymap.set({ "i" }, "<S-Tab>", "<C-D>", { noremap = true, desc = "Remove indent" })
vim.keymap.set({ "v" }, "<Tab>", ">gv", { noremap = true, desc = "Add indent" })
vim.keymap.set({ "v" }, "<S-Tab>", "<gv", { noremap = true, desc = "Remove indent" })

-- use <C-Up>, ...
-- vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -40<cr>", { noremap = true, desc = "Decrease window width" })
-- vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +40<cr>", { noremap = true, desc = "Increase window width" })
-- vim.keymap.set("n", "<S-Up>", "<cmd>horizontal resize +10<cr>", { noremap = true, desc = "Increase window height" })
-- vim.keymap.set("n", "<S-Down>", "<cmd>horizontal resize -10<cr>", { noremap = true, desc = "Decrease window height" })

-- remap gg
vim.keymap.set({ "n" }, "gg", "ggzz", { noremap = true, desc = "Go to top" })
-- remap G
vim.keymap.set({ "n" }, "G", "Gzz", { noremap = true, desc = "Go to bottom" })
-- remap jk
vim.keymap.set({ "i" }, "jk", "<Esc>", { noremap = true, desc = "jk to escape" })

-- remap dd to diff side by side
vim.keymap.set({ "n" }, "<leader>dd", "<cmd>windo diffthis<cr>", { noremap = true, desc = "Diff side by side" })
