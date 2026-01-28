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

-- remap G
vim.keymap.set({ "n" }, "G", "Gzz", { noremap = true, desc = "Go to bottom" })
-- remap jk
vim.keymap.set({ "i" }, "jk", "<Esc>", { noremap = true, desc = "jk to escape" })
vim.keymap.set({ "i" }, "JK", "<Esc>", { noremap = true, desc = "JK to escape" })
vim.keymap.set({ "i" }, "Jk", "<Esc>", { noremap = true, desc = "Jk to escape" })

-- remap page up and page down
vim.keymap.set({ "n", "v" }, "<C-d>", "5jzz")
vim.keymap.set({ "n", "v" }, "<C-u>", "5kzz")

-- remap <leader>dd to diff side by side
local function toggle_diff()
  if vim.wo.diff then
    vim.cmd("diffoff!")
  else
    vim.cmd("windo diffthis")
  end
end
vim.keymap.set({ "n" }, "<leader>dd", toggle_diff, { noremap = true, desc = "Diff side by side" })

-- Duplicate a line and comment out the first line
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p", { noremap = true, desc = "Duplicate a line and comment" })

local function duplicate_and_comment()
  -- Escape the visual mode
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)

  -- Get the selected text
  local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")

  -- Duplicate the selected lines
  vim.cmd(start_line .. "," .. end_line .. "yank")
  vim.cmd(end_line + 1 .. "put")

  -- reselect previous visual selection
  vim.api.nvim_feedkeys("gv", "n", false)

  -- comment the visual selection
  vim.api.nvim_feedkeys("gc", "v", false)
end

vim.keymap.set("v", "yc", duplicate_and_comment, { noremap = true, desc = "Duplicate selection and comment" })

-- From the Vim wiki: https://bit.ly/4eLAARp
-- Search and replace word under cursor
-- vim.keymap.set(
--   "n",
--   "<Leader>r",
--   [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
--   { desc = "Search and replace word under cursor" }
-- )
-- In visual mode, replace selected word
-- vim.keymap.set("v", "<leader>r", function()
--   local start_pos = vim.fn.getpos("v")
--   local end_pos = vim.fn.getpos(".")
--
--   local line = vim.fn.getline(start_pos[2])
--   local word = vim.trim(string.sub(line, start_pos[3], end_pos[3]))
--
--   local bufnr = vim.api.nvim_create_buf(false, true)
--   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { word })
--
--   local width = vim.api.nvim_win_get_width(0)
--   local height = vim.api.nvim_win_get_height(0)
--
--   local win_opts = {
--     title = "Search and replace",
--     relative = "editor",
--     width = math.ceil(width * 0.4),
--     height = math.ceil(height * 0.05),
--     col = math.ceil((width - width * 0.4) / 2),
--     row = math.ceil((height - height * 0.05) / 2),
--     style = "minimal",
--     border = "rounded",
--   }
--
--   Abort = false
--
--   vim.keymap.set("n", "q", function()
--     Abort = true
--     vim.api.nvim_win_close(0, true)
--   end, { noremap = true, buffer = bufnr })
--
--   vim.keymap.set("n", "<Esc>", function()
--     Abort = true
--     vim.api.nvim_win_close(0, true)
--   end, { noremap = true, buffer = bufnr })
--
--   vim.keymap.set({ "n", "i" }, "<CR>", function()
--     vim.api.nvim_win_close(0, true)
--   end, { noremap = true, buffer = bufnr })
--
--   vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
--     buffer = bufnr,
--     callback = function()
--       if Abort then
--         return
--       end
--       local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--       local new_word = vim.trim(lines[1])
--       if new_word == word then
--         return
--       end
--       vim.schedule(function()
--         vim.cmd("%s/" .. word .. "/" .. new_word .. "/gc")
--       end)
--     end,
--   })
--
--   vim.api.nvim_open_win(bufnr, true, win_opts)
-- end, { noremap = true })

vim.keymap.set({ "n" }, "<leader>v", "vg_", { noremap = true, desc = "Select to last non-blank character" })

-- my dumb ass pressing the wrong key to leave
-- yoinked from https://www.reddit.com/r/neovim/comments/1lyqqdz/why_when_i_write_a_file_does_it_disappear_from_my/
local typos = { "W", "Wq", "WQ", "Wqa", "WQa", "WQA", "WqA", "Q", "Qa", "QA" }
for _, cmd in ipairs(typos) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    vim.api.nvim_cmd({
      cmd = cmd:lower(),
      bang = opts.bang,
      mods = { noautocmd = true },
    }, {})
  end, { bang = true })
end
vim.keymap.set({ "n" }, "q:", "<nop>", { noremap = true })

-- Center search results
-- yoinked from https://vim.fandom.com/wiki/Make_search_results_appear_in_the_middle_of_the_screen
-- handled by tiny-glimmer.nvim now
-- vim.keymap.set("n", "n", "nzz", { noremap = true })
-- vim.keymap.set("n", "N", "Nzz", { noremap = true })
-- vim.keymap.set("n", "*", "*zz", { noremap = true })
-- vim.keymap.set("n", "#", "#zz", { noremap = true })
vim.keymap.set("n", "g*", "g*zz", { noremap = true })
vim.keymap.set("n", "g#", "g#zz", { noremap = true })

-- Little movement in insert mode
vim.keymap.set("i", "<C-n>", "<Down>", { noremap = true })
vim.keymap.set("i", "<C-p>", "<Up>", { noremap = true })
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true })
vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true })
vim.keymap.set("i", "<C-e>", "<C-o>$", { noremap = true })
vim.keymap.set("i", "<C-a>", "<C-o>_", { noremap = false })

-- Larger movement in insert mode
vim.keymap.set("i", "<M-f>", "<C-o>w", { noremap = true })
vim.keymap.set("i", "<M-b>", "<C-o>b", { noremap = true })

vim.keymap.set("n", ";", ":", { noremap = true })

-- / to search, then g/ to put them into the quickfix list
vim.keymap.set("n", "g/", ":vimgrep /<C-R>//j %<CR>|:cw<CR>", { noremap = true, silent = true })

-- minify lines
vim.keymap.set("v", "<leader>j", "J", { noremap = true })

local default_virutal_text = {
  prefix = "●",
  source = "if_many",
  spacing = 4,
}

-- Toggle diagnostic virtual lines and virtual text
vim.keymap.set("n", "<leader>ud", function()
  local virtual_text = false
  if vim.diagnostic.config().virtual_text == false then
    virtual_text = default_virutal_text
  end
  vim.diagnostic.config({
    virtual_lines = not vim.diagnostic.config().virtual_lines,
    virtual_text = virtual_text,
  })
end, { desc = "Toggle diagnostic virtual lines and virtual text" })

-- Move to start/end of line
vim.keymap.set({ "n", "v" }, "gh", "_", { noremap = true })
vim.keymap.set({ "n", "v" }, "gl", "$", { noremap = true })

-- Operations up to next quote
vim.keymap.set({ "n" }, "dq", "v/[\"'`]<CR><Left>d<cmd>nohlsearch<CR>", { noremap = true })
vim.keymap.set({ "n" }, "yq", "v/[\"'`]<CR><Left>y<cmd>nohlsearch<CR>", { noremap = true })
vim.keymap.set({ "n" }, "cq", "v/[\"'`]<CR><Left>di<cmd>nohlsearch<CR>", { noremap = true })

-- Disable vanilla marks
vim.keymap.set({ "n" }, "m", "<Nop>", { noremap = true })

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
  local params = vim.lsp.util.make_position_params(0, "utf-8")
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

---@param type TSNode
---@param buf number
---@return string
local function type_to_val(type, buf)
  local type_string = type:type()
  local array_ts_type = { "array_type", "slice_type" }
  local string_ts_type = {
    "channel_type",
    "function_type",
    "generic_type",
    "interface_type",
    "negated_type",
  }
  if vim.tbl_contains(array_ts_type, type_string) then
    local element = type_to_val(type:field("element")[1], buf)
    local s = ("[" .. element .. "]"):gsub("\n", "\n  ")
    return s
  end

  if vim.tbl_contains(string_ts_type, type_string) then
    return '""'
  end

  if type_string == "map_type" then
    local key = type_to_val(type:field("key")[1], buf)
    local value = type_to_val(type:field("value")[1], buf)
    local s = ("{\n" .. key .. ": " .. value):gsub("\n", "\n  ")
    return s .. "\n}"
  end

  if type_string == "pointer_type" then
    -- add options to treat pointer as non-pointer type
    return "null"
  end

  -- time.Time, xxx.xxx
  if type_string == "qualified_type" then
    local name = type:field("name")[1]

    return Create_buffer(buf, name)
  end
  if type_string == "struct_type" then
    return "{}"
  end
  if type_string == "type_identifier" then
    return Create_buffer(buf, type)
  end

  return ""
end

---@param buf number
---@param type TSNode
---@return string
function Create_buffer(buf, type)
  local row, column, _ = type:start()
  local type_text = vim.treesitter.get_node_text(type, buf)
  local uri, range = get_definition_by_position(buf, { row, column }) -- 0-indexed

  if uri and range then
    uri = uri:gsub("file://", "")
    local working_dir = vim.fn.getcwd()
    if not uri:find(working_dir, 1, true) then
      -- it is go type, don't create buffer
      return get_value_by_go_type(type_text)
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
    local value = Struct_to_json_string(c, buffer)
    if created_buffer then
      vim.api.nvim_buf_delete(buffer, { force = true, unload = false })
    end

    return value
  end
  return ""
end

---@param node TSNode|nil
---@param buf number
---@return string
function Struct_to_json_string(node, buf)
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
    local type = field:field("type")[1]
    local json_tag = extract_json_tag(field, buf)

    -- add options to marshal fields without json tag
    if json_tag then
      local value = type_to_val(type, buf)
      table.insert(json_fields, { json_tag, value })
    end
  end

  if #json_fields == 0 then
    return '""'
  end

  return concat_json_fields(json_fields)
end

local function struct_to_json()
  if not vim.bo.filetype == "go" then
    vim.notify("Not a go file", vim.log.levels.INFO)
    return
  end

  local json = Struct_to_json_string(nil, 0)

  if json == '""' then
    vim.notify("No JSON tag found", vim.log.levels.INFO)
    return
  end

  vim.fn.setreg("+", json)
  vim.notify("JSON copied to clipboard!", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>gk", struct_to_json, { desc = "JSON boilerplate" })

-- vim.keymap.set("n", "<leader>gj", function()
--   require("pr").check_pr()
-- end, { desc = "Check PR" })
--
-- vim.keymap.set("n", "<leader>gJ", function()
--   require("pr").toggle_diff()
-- end, { desc = "toggle PR diff" })
--
-- vim.keymap.set("n", "<leader>gc", function()
--   require("pr"):toggle()
-- end, { desc = "toggle PR comments" })
--
-- vim.keymap.set("n", "<leader>gp", function()
--   require("pr").popup()
-- end, { desc = "toggle PR comments" })
