local M = {}

M.enabled = false
M.bufs = {}
M.wins = {}
M.git_root = ""
M.git_user = ""
--- { owner: string, repo: string }
M.repo_info = {}
M.pr_number = 0

-- { [file] = { { [author, body, start_line, end_line, reaction_groups] } } }
M.comments = {}

M.opts = {
  virtual_text = true,
  virtual_line = true,
  sign = "󰅺",
  multi_line_sign = {
    start_line = "┌",
    connector = "│",
    end_line = "└",
  },
}

local reaction_contents = {
  CONFUSED = "😕",
  EYES = "👀",
  HEART = "❤️",
  HOORAY = "🎉",
  LAUGH = "😄",
  ROCKET = "🚀",
  THUMBS_DOWN = "👎",
  THUMBS_UP = "👍",
}

-- Sign definitions
local sign_group = "PRDiffSigns"
-- local sign_add = "PRAdd"
-- local sign_del = "PRDel"
local sign_comment = "PRComment"
local sign_comment_multi_line_start = "PRCommentMultiLineStart"
local sign_comment_multi_line_connector = "PRCommentMultiLineConnector"
local sign_comment_multi_line_end = "PRCommentMultiLineEnd"

local sign_hl = "DiffComment"
local popup_hl = "PRCommentPopup"

-- Highlight definitions
local hl_group = "PRDiffHighlights"
local hl_comment = "PRCommentHL"

local Popup = require("nui.popup")
local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event
local Job = require("plenary.job")

-- -- A single setup function for signs and highlights
-- function M.setup(opts)
--   M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
--
--   -- vim.fn.sign_define(sign_add, { text = "+", texthl = "DiffAdd" })
--   -- vim.fn.sign_define(sign_del, { text = "-", texthl = "DiffDelete" })
--   vim.fn.sign_define(sign_comment, { text = M.opts.sign, texthl = sign_hl })
--   vim.fn.sign_define(sign_comment_multi_line_start, { text = M.opts.multi_line_sign.start_line, texthl = sign_hl })
--   vim.fn.sign_define(sign_comment_multi_line_connector, { text = M.opts.multi_line_sign.connector, texthl = sign_hl })
--   vim.fn.sign_define(sign_comment_multi_line_end, { text = M.opts.multi_line_sign.end_line, texthl = sign_hl })
--   -- vim.api.nvim_set_hl(0, "DiffAdd", { fg = "Green" })
--   -- vim.api.nvim_set_hl(0, "DiffDelete", { fg = "Red" })
--   vim.api.nvim_set_hl(0, sign_hl, { fg = "LightBlue" })
--   vim.api.nvim_set_hl(0, "PRDiffAdd", { bg = "#40531b" })
--   vim.api.nvim_set_hl(0, "PRDiffDelete", { bg = "#893f45" })
--   vim.api.nvim_set_hl(0, sign_comment, { fg = "Grey", italic = true })
--   vim.api.nvim_set_hl(0, hl_comment, { bg = "LightBlue" })
--
--   vim.api.nvim_set_hl(0, popup_hl, { fg = "Yellow" })
--
--   M.get_git_root()
--   M.get_git_user()
--   M.get_repo_info()
--   M.get_comments()
--   M.get_pr_number()
-- end
--
-- -- Run setup when the module is loaded
-- M.setup()

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
---
---@param callback function?(owner: string, repo: string)
---@return nil
function M.get_repo_info(callback)
  callback = callback or function(_, _) end
  if M.repo_info.owner and M.repo_info.repo then
    callback(M.repo_info.owner, M.repo_info.repo)
    return
  end

  Job:new({
    command = "git",
    args = { "remote", "get-url", "origin" },
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        vim.api.nvim_echo({ { "Could not determine GitHub repository from remote 'origin'.", "ErrorMsg" } }, true, {})
        return
      end
      local result_json = j:result()
      local _, t = next(result_json)
      if not t then
        vim.api.nvim_echo({ { "Could not determine GitHub repository from remote 'origin'.", "ErrorMsg" } }, true, {})
        return
      end

      local remote_url = t
      -- Match git@github.com:owner/repo.git OR https://github.com/owner/repo.git
      local owner, repo = remote_url:match("[:/]([^/]+)/([^/]+)%.git$")
      if not owner then
        -- Match https://github.com/owner/repo (no .git suffix)
        owner, repo = remote_url:match("github%.com/([^/]+)/([^/]+)$")
      end
      if owner and repo then
        M.repo_info = { owner = owner, repo = repo }
        callback(owner, repo)
        return
      else
        vim.api.nvim_echo({ { "Could not determine GitHub repository from remote 'origin'.", "ErrorMsg" } }, true, {})
        return
      end
    end,
  }):start()
end

-- Helper to get the current PR number
---
---@param callback function?(pr_number: number)
function M.get_pr_number(callback)
  callback = callback or function(_) end
  if M.pr_number > 0 then
    callback(M.pr_number)
    return
  end

  Job:new({
    command = "gh",
    args = { "pr", "view", "--json", "number", "--jq", ".number" },
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        vim.api.nvim_echo({ { "Could not get PR number. Is a PR open for this branch?", "ErrorMsg" } }, true, {})
        return
      end
      local result_json = j:result()
      local _, t = next(result_json)
      if not t then
        vim.api.nvim_echo({ { "Could not get PR number. Is a PR open for this branch?", "ErrorMsg" } }, true, {})
        return
      end

      local pr_number_str = t
      local pr_number = tonumber(pr_number_str)
      if pr_number then
        M.pr_number = pr_number
        callback(pr_number)
        return
      else
        vim.notify("Could not get PR number. Is a gh cli installed?")
        return
      end
    end,
  }):start()
end

---
---@param callback function?
function M.get_comments(callback)
  callback = callback or function() end
  if next(M.comments) then
    callback()
    return
  end
  -- vim.notify(vim.inspect(M.comments))

  -- 1. Get dynamic repository and PR info
  M.get_repo_info(function(owner, repo)
    if not repo and not owner then
      vim.api.nvim_echo({ { "Could not determine GitHub repository from remote 'origin'.", "ErrorMsg" } }, true, {})
      return
    end
    M.get_pr_number(function(pr_number)
      if not pr_number then
        vim.api.nvim_echo({ { "Could not get PR number. Is a PR open for this branch?", "ErrorMsg" } }, true, {})
        return
      end
      -- 2. Construct the GraphQL query with dynamic data
      -- https://docs.github.com/en/graphql/reference/objects#pullrequestreviewcomment
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
                      startLine
                      originalLine
                      originalStartLine
                      reactionGroups {
                        content
                        viewerHasReacted
                        reactors {
                          totalCount
                        }
                      }
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
      local args = {
        "api",
        "graphql",
        "-F",
        "owner=" .. owner,
        "-F",
        "name=" .. repo,
        "-F",
        "prNumber=" .. pr_number,
        "-f",
        "query=" .. query_template,
      }
      Job:new({
        command = "gh",
        args = args,
        on_exit = function(j, return_val)
          -- vim.notify(vim.inspect(j:result()))
          if return_val ~= 0 then
            vim.notify("Error running gh api graphql command. Is a gh cli installed?")
            return
          end

          local result_json = j:result()
          local _, t = next(result_json)
          if not t then
            vim.notify("No result from gh api graphql command. Is a gh cli installed?")
            return
          end

          local data = vim.json.decode(t)
          if not data or not data.data or not data.data.repository or not data.data.repository.pullRequest then
            vim.notify("Unexpected GraphQL response structure.")
            return
          end

          local threads = data.data.repository.pullRequest.reviewThreads.edges

          local comments = {}

          for _, thread_edge in ipairs(threads) do
            local thread = {}
            local file = ""
            for _, comment_edge in ipairs(thread_edge.node.comments.edges) do
              local comment = comment_edge.node
              -- vim.notify(vim.inspect(comment))
              if comment.line ~= vim.NIL or comment.originalLine ~= vim.NIL then
                local line = comment.line
                if comment.line == vim.NIL then
                  line = comment.originalLine
                end

                local start_line = comment.startLine
                if comment.startLine == vim.NIL then
                  if comment.originalStartLine == vim.NIL then
                    start_line = line
                  else
                    start_line = comment.originalStartLine
                  end
                end
                file = comment.path
                local author = comment.author and comment.author.login or "unknown"
                table.insert(thread, {
                  author = author,
                  body = comment.body,
                  start_line = start_line,
                  end_line = line,
                  reaction_groups = comment.reactionGroups,
                })
              end
            end
            local c = comments[file] or {}
            table.insert(c, thread)
            comments[file] = c
          end

          M.comments = comments

          callback()
        end,
      }):start()
    end)
  end)
end

---
---@param buf integer?
function M.draw(buf)
  vim.notify("draw")
  buf = buf or vim.api.nvim_get_current_buf()
  if M.bufs[buf] then
    return
  end

  local buffer_path = vim.api.nvim_buf_get_name(buf)
  if buffer_path == "" then
    return
  end

  local comments_placed = 0
  M.get_git_root(vim.schedule_wrap(function(git_root)
    if git_root == nil or git_root == "" then
      vim.api.nvim_echo({ { "Not a git repository.", "WarningMsg" } }, true, {})
      return
    end

    local relative_path = buffer_path:sub(#git_root + 2)
    local comments = M.comments[relative_path] or {}
    for _, thread in ipairs(comments) do
      local c = {}
      local start_line = 0
      local end_line = 0
      for _, comment in ipairs(thread) do
        end_line = comment.end_line
        start_line = comment.start_line
        local author = comment.author
        local text = "🗨️ " .. author .. ": " .. comment.body:gsub("\r\n", " "):gsub("\n", " ")
        -- vim.api.nvim_buf_set_extmark(buf, comments_ns_id, start_line, -1, {
        --   end_line = end_line,
        --   end_col = 0,
        --   hl_group = hl_comment,
        -- })
        table.insert(c, text)
      end

      if start_line == end_line then
        vim.fn.sign_place(0, sign_group, sign_comment, buf, { lnum = end_line })
      else
        vim.fn.sign_place(0, sign_group, sign_comment_multi_line_start, buf, { lnum = start_line })
        for i = start_line + 1, end_line - 1 do
          vim.fn.sign_place(0, sign_group, sign_comment_multi_line_connector, buf, { lnum = i })
        end
        vim.fn.sign_place(0, sign_group, sign_comment_multi_line_end, buf, { lnum = end_line })
      end

      if M.opts.virtual_text then
        vim.api.nvim_buf_set_extmark(buf, comments_ns_id, end_line - 1, -1, {
          virt_text = { { table.concat(c, " | "), "PRComment" } },
          virt_text_pos = "eol",
        })
      end

      if M.opts.virtual_line then
        local virt_lines = {}
        for _, comment in ipairs(thread) do
          local author = comment.author
          local text = "🗨️ " .. author .. ": " .. comment.body:gsub("\r\n", " "):gsub("\n", " ")
          table.insert(virt_lines, { { text, "PRComment" } })
        end
        vim.api.nvim_buf_set_extmark(buf, comments_ns_id, end_line - 1, -1, {
          virt_lines = virt_lines,
          virt_text_pos = "eol",
        })
      end

      comments_placed = comments_placed + 1
    end

    M.bufs[buf] = true

    if comments_placed > 0 then
      vim.api.nvim_echo({ { comments_placed .. " PR comment threads shown.", "InfoMsg" } }, true, {})
    else
      vim.api.nvim_echo({ { "No inline PR comments found for this file.", "WarningMsg" } }, true, {})
    end
  end))
end

-- yoinked from https://github.com/folke/todo-comments.nvim/blob/304a8d204ee787d2544d8bc23cd38d2f929e7cc5/lua/todo-comments/highlight.lua#L279
-- ===========================================================================
---
---@param win integer
---@return boolean?
function M.is_float(win)
  local opts = vim.api.nvim_win_get_config(win)
  return opts and opts.relative and opts.relative ~= ""
end

---
---@param win integer
---@return boolean
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

---
---@param buf integer
---@return boolean
function M.is_quickfix(buf)
  return vim.api.nvim_buf_get_option(buf, "buftype") == "quickfix"
end

---
---@param buf integer
---@return boolean
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

---
---@param callback function?(git_root: string)
function M.get_git_root(callback)
  callback = callback or function(_) end
  if M.git_root then
    callback(M.git_root)
  end
  Job:new({
    command = "git",
    args = { "rev-parse", "--show-toplevel" },
    on_exit = function(j, return_val)
      -- vim.notify(vim.inspect(j:result()))
      if return_val ~= 0 then
        vim.notify("Error running git rev-parse command. Is a git cli installed?")
        return
      end
      local result_json = j:result()
      local _, t = next(result_json)
      if not t then
        vim.notify("No result from git rev-parse command. Is a git cli installed?")
        return
      end

      M.git_root = t
      callback(M.git_root)
    end,
  }):start()
end

---
---@param callback function?(git_user: string)
function M.get_git_user(callback)
  callback = callback or function(_) end
  if M.git_user then
    callback(M.git_user)
  end
  Job:new({
    command = "gh",
    args = { "api", "api", "user", "-q", ".login" },
    cmd = "./",
    on_exit = function(j, return_val)
      -- vim.notify(vim.inspect(j:result()))
      if return_val ~= 0 then
        vim.notify("Error running git user command. Is a git cli installed?")
        return
      end
      local result_json = j:result()
      local _, t = next(result_json)
      if not t then
        vim.notify("No result from git user command. Is a git cli installed?")
        return
      end

      M.git_user = t
      vim.notify(M.git_user)
      callback(M.git_user)
    end,
  }):start()
end

---
---@param win integer?
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
        M.bufs[buf] = nil
      end,
    })

    M.draw(buf)

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

    -- M.bufs[buf] = true
    -- M.highlight_win(win)
    M.wins[win] = true
    -- elseif not M.wins[win] then
    -- M.highlight_win(win)
    -- M.wins[win] = true
  end
end
-- ===========================================================================

---
---@param relative_path string
---@param line integer
function M.popup(relative_path, line)
  -- TODO: check M.get_comments is done
  M.get_git_root(vim.schedule_wrap(function(git_root)
    if git_root == nil or git_root == "" then
      vim.api.nvim_echo({ { "Not a git repository.", "WarningMsg" } }, true, {})
      return
    end

    local buf = vim.api.nvim_get_current_buf()
    local buffer_path = vim.api.nvim_buf_get_name(buf)
    if buffer_path == "" then
      return
    end
    relative_path = relative_path or buffer_path:sub(#git_root + 2)
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    line = line or row

    local comments = M.comments[relative_path] or {}

    for _, thread in ipairs(comments) do
      local _, first_comment = next(thread)
      if first_comment and first_comment.start_line <= line and first_comment.end_line >= line then
        local popups = {}
        for i, comment in ipairs(thread) do
          table.insert(popups, M.make_popup(comment, i == 1))
        end
        local layout = M.make_layout(popups)
        layout:mount()
        break
      end
    end
  end))
end

---
---@param comment any
---@param enter boolean
---@return NuiPopup
function M.make_popup(comment, enter)
  local popup = Popup({
    border = {
      padding = {
        top = 1,
        bottom = 1,
        left = 1,
        right = 1,
      },
      style = "rounded",
      text = {},
    },
    buf_options = {
      modifiable = false,
      readonly = true,
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
    enter = enter or false,
  })

  local buf_enter_event = { event.BufEnter }
  if enter then
    table.insert(buf_enter_event, event.BufWinEnter)
  end

  popup:on(buf_enter_event, function()
    popup.border:set_highlight(popup_hl)
  end)
  popup:on(event.BufLeave, function()
    popup.border:set_highlight("FloatBorder")
  end)
  local lines = { comment.author .. ":", unpack(M.split_crlf(comment.body)) }

  table.insert(lines, "")
  table.insert(lines, M.format_reaction(comment.reaction_groups))

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)

  -- vim.keymap.set("n", "q", function()
  --   popup:unmount()
  -- end, { buffer = popup.bufnr })

  -- vim.api.nvim_set_current_win(popup.winid)
  return popup
end

---
---@param popups NuiPopup[]
---@return NuiLayout
function M.make_layout(popups)
  local comment_boxes = {}
  for i, popup in ipairs(popups) do
    local lines = vim.api.nvim_buf_get_lines(popup.bufnr, 0, -1, true)
    -- padding
    table.insert(comment_boxes, Layout.Box(popup, { size = #lines + 4 }))
    if i == 1 then
      popup.border:set_text("top", "Inline Comment", "center")
    end

    if i == #popups then
      popup.border:set_text("bottom", " [E]moji | [C]omment | [R]esolve | [Q]uit ", "center")
    end
  end
  local new_comment_popup = Popup({
    border = {
      padding = {
        top = 1,
        bottom = 1,
        left = 1,
        right = 1,
      },
      style = "rounded",
      text = {
        top = "New Comment",
        top_align = "left",
      },
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
    enter = false,
  })

  table.insert(popups, new_comment_popup)

  new_comment_popup:on(event.BufEnter, function()
    new_comment_popup.border:set_highlight(popup_hl)
  end)
  new_comment_popup:on(event.BufLeave, function()
    new_comment_popup.border:set_highlight("FloatBorder")
  end)

  local new_comment_box = Layout.Box(new_comment_popup, { size = "40%" })

  table.insert(comment_boxes, new_comment_box)

  local layout = Layout({
    position = "50%",
    size = {
      width = 80,
      height = "60%",
    },
  }, Layout.Box(comment_boxes, { dir = "col" }))

  for i, popup in ipairs(popups) do
    popup:map("n", "q", function()
      layout:unmount()
    end)

    popup:map("n", "j", function()
      if i == #popups then
        return
      end
      vim.api.nvim_set_current_win(popups[i + 1].winid)
    end)

    popup:map("n", "k", function()
      if i == 1 then
        return
      end
      vim.api.nvim_set_current_win(popups[i - 1].winid)
    end)
  end

  return layout
end

function M.format_reaction(reaction_group)
  local reactions = {}
  for _, reaction in ipairs(reaction_group) do
    if reaction.reactors.totalCount > 0 then
      table.insert(
        reactions,
        "( " .. reaction_contents[reaction.content] .. " " .. reaction.reactors.totalCount .. " )"
      )
    end
  end
  return table.concat(reactions, " | ")
end

---
---@param s string
---@return string[]
function M.split_crlf(s)
  local res = {}
  local delim = "\r\n"
  local i = 1

  -- special-case empty string -> one empty field
  if s == "" then
    return { "" }
  end

  while true do
    local start_pos, end_pos = string.find(s, delim, i, true) -- plain find
    if not start_pos then
      table.insert(res, string.sub(s, i)) -- remainder (may be "")
      break
    end
    table.insert(res, string.sub(s, i, start_pos - 1)) -- segment before delim (may be "")
    i = end_pos + 1 -- move past the delimiter
  end

  return res
end

function M.stop()
  M.enabled = false
  M.wins = {}
  M.comments = {}
  for buf, _ in pairs(M.bufs) do
    vim.api.nvim_buf_clear_namespace(buf, diff_ns_id, 0, -1)
    vim.api.nvim_buf_clear_namespace(buf, comments_ns_id, 0, -1)
  end
  M.bufs = {}
  vim.fn.sign_unplace(sign_group)
end

function M.toggle()
  if M.enabled then
    M.stop()
  else
    M.start()
  end
end

function M.start()
  M.enabled = true
  M.get_comments(vim.schedule_wrap(function()
    vim.api.nvim_exec2(
      [[augroup PRComment
        autocmd!
        autocmd BufWinEnter,WinNew * lua require("pr").attach()
      augroup end]],
      { output = false }
    )

    -- attach to all bufs in visible windows
    for _, win in pairs(vim.api.nvim_list_wins()) do
      if not M.wins[win] then
        -- local buf = vim.api.nvim_win_get_buf(win)
        -- if not M.bufs[buf] then
        --   M.draw(buf)
        --   M.wins[win] = true
        --   M.bufs[buf] = true
        -- end
        M.attach(win)
      end
    end
  end))
end

-- A single setup function for signs and highlights
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  -- vim.fn.sign_define(sign_add, { text = "+", texthl = "DiffAdd" })
  -- vim.fn.sign_define(sign_del, { text = "-", texthl = "DiffDelete" })
  vim.fn.sign_define(sign_comment, { text = M.opts.sign, texthl = sign_hl })
  vim.fn.sign_define(sign_comment_multi_line_start, { text = M.opts.multi_line_sign.start_line, texthl = sign_hl })
  vim.fn.sign_define(sign_comment_multi_line_connector, { text = M.opts.multi_line_sign.connector, texthl = sign_hl })
  vim.fn.sign_define(sign_comment_multi_line_end, { text = M.opts.multi_line_sign.end_line, texthl = sign_hl })
  -- vim.api.nvim_set_hl(0, "DiffAdd", { fg = "Green" })
  -- vim.api.nvim_set_hl(0, "DiffDelete", { fg = "Red" })
  vim.api.nvim_set_hl(0, sign_hl, { fg = "LightBlue" })
  vim.api.nvim_set_hl(0, "PRDiffAdd", { bg = "#40531b" })
  vim.api.nvim_set_hl(0, "PRDiffDelete", { bg = "#893f45" })
  vim.api.nvim_set_hl(0, sign_comment, { fg = "Grey", italic = true })
  vim.api.nvim_set_hl(0, hl_comment, { bg = "LightBlue" })

  vim.api.nvim_set_hl(0, popup_hl, { fg = "Yellow" })

  M.get_git_root()
  M.get_git_user()
  M.get_repo_info()
  M.get_comments()
  M.get_pr_number()
end

-- Run setup when the module is loaded
M.setup()

return M
