-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n" }, "cfp", '<cmd>let @+ = expand("%")<CR>', { noremap = true, desc = "Copy file relative path" })
vim.keymap.set({ "n" }, "cfP", '<cmd>let @+ = expand("%:p")<CR>', { noremap = true, desc = "Copy file absolute path" })
vim.keymap.set({ "n" }, "cfn", '<cmd>let @+ = expand("%:t")<CR>', { noremap = true, desc = "Copy filename" })
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
vim.keymap.set({ "i" }, "JK", "<Esc>", { noremap = true, desc = "JK to escape" })

-- remap dd to diff side by side
vim.keymap.set({ "n" }, "<leader>dd", "<cmd>windo diffthis<cr>", { noremap = true, desc = "Diff side by side" })

-- Duplicate a line and comment out the first line
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p", { noremap = true, desc = "Duplicate a line and comment" })

-- From the Vim wiki: https://bit.ly/4eLAARp
-- Search and replace word under the cursor
vim.keymap.set(
  "n",
  "<Leader>r",
  [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "Search and replace word under the cursor" }
)
-- In visual mode, replace selected word
vim.keymap.set("v", "<Leader>r", [["zy:%s/\<<C-r>z//g<Left><Left>]], { desc = "Search and replace selected word" })

vim.keymap.set({ "n", "v" }, "<S-j>", "<cmd>Treewalker Down<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<S-k>", "<cmd>Treewalker Up<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<S-h>", "<cmd>Treewalker Left<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<S-l>", "<cmd>Treewalker Right<CR>", { noremap = true })

vim.keymap.set({ "n" }, "<leader>v", "vg_", { noremap = true, desc = "Select to last non-blank character" })

-- my dumb ass pressing the wrong key to leave
vim.keymap.set({ "n" }, "q:", "<cmd>q<CR>", { noremap = true })
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("Q", "q", {})

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

---@param node TSNode|nil
local function extract_json_tag(node, buf)
  if not node then
    return nil
  end

  local tags = node:field("tag")[1]
  if not tags then
    return nil
  end

  if tags == "" or tags == "-" then
    return nil
  end

  local tags_text = vim.treesitter.get_node_text(tags, buf)
  return tags_text:match('json:"(.-)"')
end

---@param json_fields string[][]
local function concat_json_fields(json_fields)
  local json_lines = {}
  table.insert(json_lines, "{")

  for _, field in ipairs(json_fields) do
    local key = field[1]
    local val = field[2]
    -- Indent nested json
    if val:sub(1, 1) == "{" then
      val = val:gsub("\n", "\n  ")
    end
    table.insert(json_lines, string.format('  "%s": %s,', key, val))
  end

  if #json_lines > 1 then
    json_lines[#json_lines] = json_lines[#json_lines]:sub(1, -2)
  end

  table.insert(json_lines, "}")

  return table.concat(json_lines, "\n")
end

local function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

local function find_buffer_by_name(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == name then
      return buf
    end
  end
  return -1
end

local int_types = { "int", "int8", "int16", "int32", "int64", "uint", "uint8", "uint16", "uint32", "uint64" }
local float_types = { "float32", "float64" }
local string_types = { "string" }
local bool_types = { "bool" }

---@param type string
---@return string
local function get_value_by_go_type(type)
  -- TODO: Handle map
  -- e.g. map[CardColor][]string

  -- FIXME: Don't think this is correct for slices nor map
  if type:find("[]", 1, true) then
    return "{}"
  end

  -- TODO: add option to treat pointer as non-pointer type
  -- FIXME: also this will fail for a map pointer
  if type:find("*", 1, true) then
    return "null"
  end

  if vim.tbl_contains(int_types, type) then
    return "0"
  end
  if vim.tbl_contains(float_types, type) then
    return "0.0"
  end
  if vim.tbl_contains(string_types, type) then
    return '""'
  end
  if vim.tbl_contains(bool_types, type) then
    return "false"
  end
  return ""
end

-- Definition found at: file://<CWD>/src/main.go { ["end"] = { ["character"] = 17,["line"] = 8,} ,["start"] = { ["character"] = 5,["line"] = 8,} ,}
-- it is 0-indexed, so it is line 9, column 6
---@return string | nil, {}
local function get_definition_by_position(bufnr, position)
  -- Use the current buffer if none is provided
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Prepare the parameters for the LSP request
  local params = vim.lsp.util.make_position_params(0)
  params.position.line = position[1] -- Line (0-indexed)
  params.position.character = position[2] -- Column (0-indexed)
  -- change the uri manually as make_position_params can only handle buffers with a window
  params.textDocument.uri = vim.uri_from_bufnr(bufnr)

  -- Send the request to the LSP server
  local result, err = vim.lsp.buf_request_sync(bufnr, "textDocument/definition", params, 5000)
  if err then
    vim.notify("Error getting definition: " .. err, vim.log.levels.ERROR)
    return nil, nil
  end

  if not result or vim.tbl_isempty(result) then
    vim.notify("No definition found", vim.log.levels.INFO)
    return nil, nil
  end

  -- Handle single or multiple results
  local definition = result[1]
  if definition.error then
    vim.notify("Error getting definition: " .. definition.error.message, vim.log.levels.ERROR)
    return nil, nil
  end

  local src = definition.result[1] or definition.result

  if src.uri then
    return src.uri, src.range
  elseif src.targetUri then
    return src.targetUri, src.targetRange
  else
    vim.notify("Unexpected result format" .. dump(src), vim.log.levels.WARN)
    return nil, nil
  end
end

local buffer_to_string = function(buf)
  local content = vim.api.nvim_buf_get_lines(buf, 0, vim.api.nvim_buf_line_count(buf), false)
  return table.concat(content, "\n")
end

---@param node TSNode|nil
---@param buf number
---@return string
local function struct_to_json_string(node, buf)
  if node == nil then
    local current_line = vim.fn.getline(".")
    if not current_line:find("struct", 1, true) then
      return '""'
    end

    node = vim.treesitter.get_node()
  end

  if node == nil then
    vim.notify("No node", vim.log.levels.INFO)
    return '""'
  end

  local type_declaration = find_node_ancestor({ "type_declaration" }, node)
  if node:type() == "type_declaration" then
    type_declaration = node
  end

  if type_declaration == nil then
    vim.notify("No type declaration", vim.log.levels.INFO)
    return '""'
  end

  local field_declaration_list = find_node_child({ "field_declaration_list" }, type_declaration)
  if field_declaration_list == nil then
    vim.notify("No field declaration list", vim.log.levels.INFO)
    return '""'
  end

  local json_fields = {}

  for _, field in ipairs(field_declaration_list:named_children()) do
    -- TODO: Handle nested fields
    local type = field:field("type")[1]
    local json_tag = extract_json_tag(field, buf)

    -- default value
    local value = get_value_by_go_type("string")
    if json_tag then
      local row, column, _ = type:start()
      -- vim.notify("row" .. row .. "column" .. column, vim.log.levels.INFO)
      -- FIXME:  *time.Time will only jump if the cursor is on `Time`
      local uri, range = get_definition_by_position(buf, { row, column }) -- 0-indexed

      if uri and range then
        uri = uri:gsub("file://", "")
        local working_dir = vim.fn.getcwd()
        local type_text = vim.treesitter.get_node_text(type, buf)
        if not uri:find(working_dir, 1, true) then
          -- it is go type, don't create buffer
          value = get_value_by_go_type(type_text)
          goto continue
        end
        local escaped_working_dir = working_dir:gsub("([^%w])", "%%%1")
        local f = uri:gsub(escaped_working_dir, ".")
        local buffer = find_buffer_by_name(uri)

        local created_buffer = false
        if buffer == -1 then
          buffer = vim.api.nvim_create_buf(true, false)
          vim.api.nvim_buf_set_name(buffer, f)
          vim.api.nvim_buf_call(buffer, vim.cmd.edit)
          created_buffer = true
        end

        vim.treesitter.get_parser(buffer, "go"):parse(true)

        local c = vim.treesitter.get_node({
          bufnr = buffer,
          lang = "go",
          pos = { range.start.line, range.start.character },
        })

        -- Recursively get value
        value = struct_to_json_string(c, buffer)
        if created_buffer then
          vim.api.nvim_buf_delete(buffer, { force = true, unload = false })
        end
      end
      ::continue::
      table.insert(json_fields, { json_tag, value })
    end
  end

  if #json_fields == 0 then
    return '""'
  end

  -- print(dump(json_fields))
  return concat_json_fields(json_fields)
end

local function struct_to_json()
  if not vim.bo.filetype == "go" then
    vim.notify("Not a go file", vim.log.levels.INFO)
    return
  end

  local json = struct_to_json_string(nil, 0)

  if json == '""' then
    vim.notify("No JSON tag found", vim.log.levels.INFO)
    return
  end

  vim.fn.setreg("+", json)
  vim.notify("JSON copied to clipboard!", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>gk", struct_to_json, { desc = "JSON boilerplate" })
