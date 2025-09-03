local M = {}

M.enabled = false
M.bufs = {}
M.wins = {}

-- { [file] = { { [author, body, start_line, end_line] } } }
M.comments = {}

-- Sign definitions
local sign_group = "PRDiffSigns"
-- local sign_add = "PRAdd"
-- local sign_del = "PRDel"
local sign_comment = "PRComment"

-- Highlight definitions
local hl_group = "PRDiffHighlights"
local hl_comment = "PRCommentHL"

local Popup = require("nui.popup")
local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event

local popup_one, popup_two =
  Popup({
    border = {
      padding = {
        top = 1,
        bottom = 1,
        left = 1,
        right = 1,
      },
      style = "rounded",
      text = {
        top = "Inline Comment",
        top_align = "center",
        -- bottom = "I am bottom title",
        -- bottom_align = "left",
      },
    },
  }), Popup({
    border = "double",
  })

local layout = Layout(
  {
    position = "50%",
    size = {
      width = 80,
      height = "60%",
    },
  },
  Layout.Box({
    Layout.Box(popup_one, { size = "40%" }),
    Layout.Box(popup_two, { size = "60%" }),
  }, { dir = "col" })
)

-- A single setup function for signs and highlights
local function setup_highlights_and_signs()
  -- vim.fn.sign_define(sign_add, { text = "+", texthl = "DiffAdd" })
  -- vim.fn.sign_define(sign_del, { text = "-", texthl = "DiffDelete" })
  vim.fn.sign_define(sign_comment, { text = "󰅺", texthl = "DiffComment" })
  -- vim.api.nvim_set_hl(0, "DiffAdd", { fg = "Green" })
  -- vim.api.nvim_set_hl(0, "DiffDelete", { fg = "Red" })
  vim.api.nvim_set_hl(0, "DiffComment", { fg = "LightBlue" })
  vim.api.nvim_set_hl(0, "PRDiffAdd", { bg = "#40531b" })
  vim.api.nvim_set_hl(0, "PRDiffDelete", { bg = "#893f45" })
  vim.api.nvim_set_hl(0, "PRComment", { fg = "Grey", italic = true })
  vim.api.nvim_set_hl(0, hl_comment, { bg = "LightBlue" })
end

-- Run setup when the module is loaded
setup_highlights_and_signs()

local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
local pr_info_cmd = "gh pr view --json url --jq .url"

-- State tracking
local highlights_active = false
local comments_active = false

-- Namespaces and Groups
local diff_ns_id = vim.api.nvim_create_namespace("PRDiffHighlights")
local comments_ns_id = vim.api.nvim_create_namespace("PRComments")

function M.check_pr()
  local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
  local pr_info_cmd = "gh pr view --json url --jq .url"
  local pr_info = vim.fn.system(pr_info_cmd)

  if vim.v.shell_error == 0 and pr_info ~= "" and pr_info ~= "\n" then
    vim.api.nvim_echo({ { "Pull request for branch '" .. branch .. "' is open: " .. pr_info, "InfoMsg" } }, true, {})
  else
    vim.api.nvim_echo({ { "No open pull request found for branch '" .. branch .. "'", "WarningMsg" } }, true, {})
  end
end

-- Function to clear all the diff highlights for the current buffer
local function clear_highlights()
  vim.api.nvim_buf_clear_namespace(0, diff_ns_id, 0, -1)
  vim.api.nvim_echo({ { "PR diff highlights removed.", "InfoMsg" } }, true, {})
end

-- Function to get the diff and place the highlights
local function place_highlights()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  if buffer_path == "" then
    vim.api.nvim_echo({ { "Cannot get diff for an unnamed buffer.", "WarningMsg" } }, true, {})
    return
  end

  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root == nil or git_root == "" then
    vim.api.nvim_echo({ { "Not a git repository.", "WarningMsg" } }, true, {})
    return
  end

  local relative_path = buffer_path:sub(#git_root + 2)
  local diff_lines = vim.fn.systemlist("gh pr diff")

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Could not get PR diff. Is a PR open for this branch?", "ErrorMsg" } }, true, {})
    return
  end

  local current_file_diff = false
  local line_num_in_buffer = 0
  local highlights_placed = 0

  for _, line in ipairs(diff_lines) do
    -- Check for the start of a new file's diff
    local diff_file = line:match("^diff %-%-git a/.+ b/(.+)$")
    if diff_file then
      current_file_diff = (diff_file == relative_path)
      line_num_in_buffer = 0 -- Reset for new file
    end

    if current_file_diff then
      local start_line_str = line:match("^@@ %-.+ %+([0-9]+)")
      if start_line_str then
        -- The line number from the hunk refers to the first line of the new content.
        -- We adjust it to be the line *before* the first hunk line, so our
        -- counter is correct after the first increment.
        line_num_in_buffer = tonumber(start_line_str) - 1
      end

      -- Only process diff lines after a hunk header has been found for this file
      if line_num_in_buffer >= 0 then
        if line:sub(1, 1) == "+" then
          line_num_in_buffer = line_num_in_buffer + 1
          vim.api.nvim_buf_add_highlight(0, diff_ns_id, "PRDiffAdd", line_num_in_buffer - 1, 0, -1)
          highlights_placed = highlights_placed + 1
        elseif line:sub(1, 1) == " " then
          line_num_in_buffer = line_num_in_buffer + 1
        elseif line:sub(1, 1) == "-" then
          -- A deleted line doesn't exist in the buffer, so we don't increment the line counter.
          -- We highlight the line before the deletion, if possible.
          if line_num_in_buffer > 0 then
            vim.api.nvim_buf_add_highlight(0, diff_ns_id, "PRDiffDelete", line_num_in_buffer - 1, 0, -1)
            highlights_placed = highlights_placed + 1
          end
        end
      end
    end
  end

  if highlights_placed > 0 then
    vim.api.nvim_echo({ { "PR diff highlights placed for " .. relative_path, "InfoMsg" } }, true, {})
  else
    vim.api.nvim_echo({ { "No PR changes found for the current file.", "WarningMsg" } }, true, {})
  end
end

-- The main toggle function called by the user command
function M.toggle_diff()
  if highlights_active then
    clear_highlights()
    highlights_active = false
  else
    place_highlights()
    highlights_active = true
  end
end

local function clear_comments()
  vim.api.nvim_buf_clear_namespace(0, comments_ns_id, 0, -1)
  vim.api.nvim_echo({ { "PR comments hidden.", "InfoMsg" } }, true, {})
end

-- Helper to get owner/repo from git remote
local function get_repo_info()
  local remote_url = vim.fn.systemlist("git remote get-url origin")[1]
  if not remote_url then
    return nil
  end
  -- Match git@github.com:owner/repo.git OR https://github.com/owner/repo.git
  local owner, repo = remote_url:match("[:/]([^/]+)/([^/]+)%.git$")
  if not owner then
    -- Match https://github.com/owner/repo (no .git suffix)
    owner, repo = remote_url:match("github%.com/([^/]+)/([^/]+)$")
  end
  if owner and repo then
    return { owner = owner, repo = repo }
  else
    return nil
  end
end

-- Helper to get the current PR number
local function get_pr_number()
  local pr_number_str = vim.fn.system("gh pr view --json number --jq .number")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return tonumber(pr_number_str)
end

local function place_comments()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  if buffer_path == "" then
    return
  end
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root == nil or git_root == "" then
    return
  end

  -- 1. Get dynamic repository and PR info
  local repo_info = get_repo_info()
  if not repo_info then
    vim.api.nvim_echo({ { "Could not determine GitHub repository from remote 'origin'.", "ErrorMsg" } }, true, {})
    return
  end
  local pr_number = get_pr_number()
  if not pr_number then
    vim.api.nvim_echo({ { "Could not get PR number. Is a PR open for this branch?", "ErrorMsg" } }, true, {})
    return
  end

  -- 2. Construct the GraphQL query with dynamic data
  local query_template = [[
    query($owner: String!, $name: String!, $prNumber: Int!) {
      repository(owner: $owner, name: $name) {
        pullRequest(number: $prNumber) {
          reviewThreads(first: 100) {
            edges {
              node {
                comments(first: 100) {
                  edges {
                    node {
                      author { login }
                      body
                      path
                      line
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  ]]

  -- 3. Execute the gh api graphql command safely
  local command = {
    "gh",
    "api",
    "graphql",
    "-F",
    "owner=" .. repo_info.owner,
    "-F",
    "name=" .. repo_info.repo,
    "-F",
    "prNumber=" .. pr_number,
    "-f",
    "query=" .. query_template,
  }
  local result_json = vim.fn.system(command)

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "GraphQL API call failed.", "ErrorMsg" } }, true, {})
    return
  end

  -- 4. Decode and parse the deep JSON structure
  local data = vim.fn.json_decode(result_json)
  if not data or not data.data or not data.data.repository or not data.data.repository.pullRequest then
    vim.api.nvim_echo({ { "Unexpected GraphQL response structure.", "WarningMsg" } }, true, {})
    return
  end

  local threads = data.data.repository.pullRequest.reviewThreads.edges
  local comments_by_line = {}
  local comments_placed = 0
  local relative_path = buffer_path:sub(#git_root + 2)

  for _, thread_edge in ipairs(threads) do
    for _, comment_edge in ipairs(thread_edge.node.comments.edges) do
      local comment = comment_edge.node
      if comment.path == relative_path and comment.line then
        local line = comment.line
        local start_line = comment.start_line or line
        local author = comment.author and comment.author.login or "unknown"
        local text = "🗨️ " .. author .. ": " .. comment.body:gsub("\r\n", " "):gsub("\n", " ")
        vim.api.nvim_buf_set_extmark(0, comments_ns_id, start_line, -1, {
          end_line = line,
          end_col = 0,
          hl_group = hl_comment,
        })
        if comments_by_line[line] then
          comments_by_line[line] = comments_by_line[line] .. " | " .. text
        else
          comments_by_line[line] = text
        end
      end
    end
  end

  -- 5. Place the comments as virtual text (unchanged logic)
  for line, text in pairs(comments_by_line) do
    vim.fn.sign_place(0, sign_group, sign_comment, "%", { lnum = line })
    vim.api.nvim_buf_set_extmark(0, comments_ns_id, line - 1, -1, {
      virt_text = { { text, "PRComment" } },
      virt_text_pos = "eol",
    })
    vim.api.nvim_buf_set_extmark(0, comments_ns_id, line - 1, -1, {
      virt_lines = { { { text, "PRComment" } } },
      virt_text_pos = "eol",
    })

    comments_placed = comments_placed + 1
  end

  if comments_placed > 0 then
    vim.api.nvim_echo({ { comments_placed .. " PR comment threads shown.", "InfoMsg" } }, true, {})
  else
    vim.api.nvim_echo({ { "No inline PR comments found for this file.", "WarningMsg" } }, true, {})
  end
end

function M.get_comments()
  if not M.comments == {} then
    return
  end

  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root == nil or git_root == "" then
    return
  end

  -- 1. Get dynamic repository and PR info
  local repo_info = get_repo_info()
  if not repo_info then
    vim.api.nvim_echo({ { "Could not determine GitHub repository from remote 'origin'.", "ErrorMsg" } }, true, {})
    return
  end
  local pr_number = get_pr_number()
  if not pr_number then
    vim.api.nvim_echo({ { "Could not get PR number. Is a PR open for this branch?", "ErrorMsg" } }, true, {})
    return
  end

  -- 2. Construct the GraphQL query with dynamic data
  local query_template = [[
    query($owner: String!, $name: String!, $prNumber: Int!) {
      repository(owner: $owner, name: $name) {
        pullRequest(number: $prNumber) {
          reviewThreads(first: 100) {
            edges {
              node {
                comments(first: 100) {
                  edges {
                    node {
                      author { login }
                      body
                      path
                      line
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  ]]

  -- 3. Execute the gh api graphql command safely
  local command = {
    "gh",
    "api",
    "graphql",
    "-F",
    "owner=" .. repo_info.owner,
    "-F",
    "name=" .. repo_info.repo,
    "-F",
    "prNumber=" .. pr_number,
    "-f",
    "query=" .. query_template,
  }
  local result_json = vim.fn.system(command)

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "GraphQL API call failed.", "ErrorMsg" } }, true, {})
    return
  end

  -- 4. Decode and parse the deep JSON structure
  local data = vim.fn.json_decode(result_json)
  if not data or not data.data or not data.data.repository or not data.data.repository.pullRequest then
    vim.api.nvim_echo({ { "Unexpected GraphQL response structure.", "WarningMsg" } }, true, {})
    return
  end

  local threads = data.data.repository.pullRequest.reviewThreads.edges

  for _, thread_edge in ipairs(threads) do
    local thread = {}
    local file = ""
    for _, comment_edge in ipairs(thread_edge.node.comments.edges) do
      local comment = comment_edge.node
      if comment.line then
        local line = comment.line
        local start_line = comment.start_line or line
        file = comment.path
        local author = comment.author and comment.author.login or "unknown"
        table.insert(thread, { author, body = comment.body, start_line = start_line, end_line = line })
      end
    end
    local c = M.comments[file] or {}
    table.insert(c, thread)
    M.comments[file] = c
  end
end

function M.draw(buf)
  vim.notify("draw")
  local buf = buf or vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(buf)
  if buffer_path == "" then
    return
  end

  local comments_placed = 0
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root == nil or git_root == "" then
    vim.api.nvim_echo({ { "Not a git repository.", "WarningMsg" } }, true, {})
    return
  end
  local relative_path = buffer_path:sub(#git_root + 2)

  M.get_comments()
  local comments = M.comments[relative_path] or {}
  for _, thread in ipairs(comments) do
    local c = {}
    local start_line = 0
    local end_line = 0
    for _, comment in ipairs(thread) do
      end_line = comment.end_line
      start_line = comment.start_line or end_line
      local author = comment.author and comment.author.login or "unknown"
      local text = "🗨️ " .. author .. ": " .. comment.body:gsub("\r\n", " "):gsub("\n", " ")
      vim.api.nvim_buf_set_extmark(buf, comments_ns_id, start_line, -1, {
        end_line = end_line,
        end_col = 0,
        hl_group = hl_comment,
      })
      table.insert(c, text)
    end

    vim.fn.sign_place(0, sign_group, sign_comment, buf, { lnum = end_line })
    vim.api.nvim_buf_set_extmark(buf, comments_ns_id, end_line - 1, -1, {
      virt_text = { { table.concat(c, " | "), "PRComment" } },
      virt_text_pos = "eol",
    })

    local virt_lines = {}
    for _, comment in ipairs(thread) do
      local author = comment.author and comment.author.login or "unknown"
      local text = "🗨️ " .. author .. ": " .. comment.body:gsub("\r\n", " "):gsub("\n", " ")
      table.insert(virt_lines, { { text, "PRComment" } })
    end
    vim.api.nvim_buf_set_extmark(buf, comments_ns_id, end_line - 1, -1, {
      virt_lines = virt_lines,
      virt_text_pos = "eol",
    })

    comments_placed = comments_placed + 1
  end

  if comments_placed > 0 then
    vim.api.nvim_echo({ { comments_placed .. " PR comment threads shown.", "InfoMsg" } }, true, {})
  else
    vim.api.nvim_echo({ { "No inline PR comments found for this file.", "WarningMsg" } }, true, {})
  end
end

-- yoinked from https://github.com/folke/todo-comments.nvim/blob/304a8d204ee787d2544d8bc23cd38d2f929e7cc5/lua/todo-comments/highlight.lua#L279
-- ===========================================================================
function M.is_float(win)
  local opts = vim.api.nvim_win_get_config(win)
  return opts and opts.relative and opts.relative ~= ""
end

function M.is_valid_win(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end
  -- avoid E5108 after pressing q:
  if vim.fn.getcmdwintype() ~= "" then
    return false
  end
  -- dont do anything for floating windows
  if M.is_float(win) then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(win)
  return M.is_valid_buf(buf)
end

function M.is_quickfix(buf)
  return vim.api.nvim_buf_get_option(buf, "buftype") == "quickfix"
end

function M.is_valid_buf(buf)
  -- Skip special buffers
  local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
  if buftype ~= "" and buftype ~= "quickfix" then
    return false
  end
  -- local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  -- TODO: config
  -- if vim.tbl_contains({}, filetype) then
  --   return false
  -- end
  return true
end

function M.attach(win)
  win = win or vim.api.nvim_get_current_win()
  if not M.is_valid_win(win) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)

  if not M.bufs[buf] then
    vim.notify("attach")
    vim.api.nvim_buf_attach(buf, false, {
      on_lines = function()
        if not M.enabled then
          return true
        end
        -- detach from this buffer in case we no longer want it
        if not M.is_valid_buf(buf) then
          return true
        end

        M.draw(buf)
      end,
      on_detach = function()
        M.state[buf] = nil
        M.bufs[buf] = nil
      end,
    })

    -- local highlighter = require("vim.treesitter.highlighter")
    -- local hl = highlighter.active[buf]
    -- if hl then
    --   -- also listen to TS changes so we can properly update the buffer based on is_comment
    --   hl.tree:register_cbs({
    --     on_bytes = function(_, _, row)
    --       M.redraw(buf, row, row + 1)
    --     end,
    --     on_changedtree = function(changes)
    --       for _, ch in ipairs(changes or {}) do
    --         M.redraw(buf, ch[1], ch[3] + 1)
    --       end
    --     end,
    --   })
    -- end

    M.bufs[buf] = true
    -- M.highlight_win(win)
    M.wins[win] = true
  elseif not M.wins[win] then
    -- M.highlight_win(win)
    M.wins[win] = true
  end
end
-- ===========================================================================

function M.toggle_comments()
  comments_active = not comments_active
  if comments_active then
    place_comments()
    layout:mount()
    popup_one:on(event.BufLeave, function()
      popup_one:unmount()
    end)
    vim.api.nvim_buf_set_lines(popup_one.bufnr, 0, 1, false, { "Hello World" })
  else
    clear_comments()
  end
end

function M.start()
  if M.enabled then
    M.enabled = false
    -- M.stop()
  end
  M.enabled = true
  vim.api.nvim_exec(
    [[augroup PRComment
        autocmd!
        autocmd BufWinEnter,WinNew * lua require("pr").draw()
      augroup end]],
    false
  )

  -- attach to all bufs in visible windows
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if not M.wins[win] then
      local buf = vim.api.nvim_win_get_buf(win)
      if not M.bufs[buf] then
        M.draw(buf)
        M.wins[win] = true
        M.bufs[buf] = true
      end
      -- M.attach(win)
    end
  end
end

return M
