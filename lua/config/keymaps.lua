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

vim.keymap.set("v", "<leader>gj", function()
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  local vstart = vim.fn.getpos("'<")

  local vend = vim.fn.getpos("'>")

  local line_start = vstart[2]
  local line_end = vend[2]

  -- or use api.nvim_buf_get_lines
  local lines = vim.fn.getline(line_start, line_end)

  if type(lines) == "string" then
    lines = { lines }
  end

  local json_lines = {}
  table.insert(json_lines, "{")

  for _, line in ipairs(lines) do
    local key = line:match('json:"(.-)"')
    if key then
      table.insert(json_lines, string.format('  "%s": "",', key))
    end
  end

  if #json_lines > 1 then
    json_lines[#json_lines] = json_lines[#json_lines]:sub(1, -2)
  end

  table.insert(json_lines, "}")

  -- Copy the result to the clipboard
  local json_string = table.concat(json_lines, "\n")
  vim.fn.setreg("+", json_string)
  print("JSON copied to clipboard!")
end, { desc = "JSON boilerplate" })

---@param types string[] Will return the first node that matches one of these types
---@param node TSNode|nil
---@return TSNode|nil
local function find_node_ancestor(types, node)
  if not node then
    return nil
  end

  if vim.tbl_contains(types, node:type()) then
    return node
  end

  local parent = node:parent()

  return find_node_ancestor(types, parent)
end

---@param types string[] Will return the first node that matches one of these types
---@param node TSNode|nil
---@return TSNode|nil
local function find_node_child(types, node)
  if not node then
    return nil
  end

  if vim.tbl_contains(types, node:type()) then
    return node
  end

  for child in node:iter_children() do
    local result = find_node_child(types, child)
    if result then
      return result
    end
  end
end

vim.keymap.set("n", "<leader>gk", function()
  local current_line = vim.fn.getline(".")

  if not current_line:find("struct", 1, true) then
    return print("Not a struct")
  end

  local node = vim.treesitter.get_node()

  local type_declaration = find_node_ancestor({ "type_declaration" }, node)

  local field_declaration_list = find_node_child({ "field_declaration_list" }, type_declaration)
  if field_declaration_list == nil then
    return print("No field declaration list")
  end

  for node in field_declaration_list:iter_children() do
    print(node.field)
  end
end, { desc = "JSON boilerplate" })
