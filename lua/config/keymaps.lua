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
local function extract_json_tag(node)
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

  local tags_text = vim.treesitter.get_node_text(tags, 0)
  return tags_text:match('json:"(.-)"')
end

---@param json_fields string[][]
local function concat_json_fields(json_fields)
  local json_lines = {}
  table.insert(json_lines, "{")

  for _, field in ipairs(json_fields) do
    table.insert(json_lines, string.format('  "%s": %s,', field[1], field[2]))
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
  -- TODO: Handle pointer
  if type:find("[]", 1, true) then
    return "{}"
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
  local params = vim.lsp.util.make_position_params(bufnr)
  params.position.line = position[1] -- Line (0-indexed)
  params.position.character = position[2] -- Column (0-indexed)

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
  print(dump(src))

  if src.uri then
    -- Single src result
    -- print("src found at:", src.uri, dump(src.range))
    return src.uri, src.range
  elseif src.targetUri then
    -- Handle `LocationLink` result
    -- print("src found at:", src.targetUri, dump(src.targetRange))
    return src.targetUri, src.targetRange
  else
    vim.notify("Unexpected result format" .. dump(src), vim.log.levels.WARN)
    return nil, nil
  end
end

local function find_node_in_file(filename, line, column)
  local parser = vim.treesitter.get_parser(filename, "go")
  if not parser then
    print("No parser found for file: " .. filename)
    return nil
  end

  local tree = parser:parse()[1] -- Get the first tree
  local root = tree:root()

  local node_at_pos = root:named_descendant_for_range(line - 1, column, line + 1, column + 10)
  if node_at_pos then
    print("Node type: " .. node_at_pos:type())
    print("Node text: " .. vim.treesitter.get_node_text(node_at_pos, 0))
    return node_at_pos
  else
    print("No node found at position")
    return nil
  end
end

local buffer_to_string = function(buf)
  local content = vim.api.nvim_buf_get_lines(buf, 0, vim.api.nvim_buf_line_count(buf), false)
  return table.concat(content, "\n")
end

---@param node TSNode|nil
---@return string
local function struct_to_json_string(node)
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
    -- TODO: Handle struct types
    local type = field:field("type")[1]
    local json_tag = extract_json_tag(field)
    -- default value
    local value = get_value_by_go_type("string")
    if json_tag then
      local row, column, _ = type:start()
      local uri, range = get_definition_by_position(0, { row, column }) -- 0-indexed
      if uri and range then
        uri = uri:gsub("file://", "")
        local working_dir = vim.fn.getcwd()
        local type_text = vim.treesitter.get_node_text(type, 0)
        if not uri:find(working_dir, 1, true) then
          -- it is go type, don't create buffer
          value = get_value_by_go_type(type_text)
          goto continue
        end
        local escaped_working_dir = working_dir:gsub("([^%w])", "%%%1")
        local f = uri:gsub(escaped_working_dir, ".")
        local buffer = find_buffer_by_name(uri)

        -- vim.notify("buffer" .. buffer, vim.log.levels.INFO)
        -- vim.notify("file" .. f, vim.log.levels.INFO)
        local created_buffer = false
        if buffer == -1 then
          buffer = vim.api.nvim_create_buf(true, false)
          vim.api.nvim_buf_set_name(buffer, f)
          vim.api.nvim_buf_call(buffer, vim.cmd.edit)
          created_buffer = true
        end

        -- vim.notify("buffer" .. buffer_to_string(buffer), vim.log.levels.INFO)

        vim.treesitter.get_parser(buffer, "go"):parse(true)

        local c = vim.treesitter.get_node({
          bufnr = buffer,
          lang = "go",
          pos = { range.start.line, range.start.character },
        })

        -- vim.notify("node" .. c:byte_length(), vim.log.levels.INFO)

        -- Recursively get value
        value = struct_to_json_string(c)
        vim.notify("recursively" .. value, vim.log.levels.INFO)
        if created_buffer then
          vim.api.nvim_buf_delete(buffer, { force = true, unload = false })
        end
      end
      ::continue::
      table.insert(json_fields, { json_tag, value })
    end
  end

  if #json_fields == 0 then
    -- vim.notify("No fields with json tag found", vim.log.levels.INFO)
    return '""'
  end

  -- print(dump(json_fields))
  return concat_json_fields(json_fields)
end

local function struct_to_json()
  local json = struct_to_json_string()

  if json == '""' then
    vim.notify("No JSON tag found", vim.log.levels.INFO)
    return
  end

  vim.fn.setreg("+", json)
  vim.notify("JSON copied to clipboard!", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>gk", struct_to_json, { desc = "JSON boilerplate" })
