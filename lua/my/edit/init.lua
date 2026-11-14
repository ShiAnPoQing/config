--- @class my.edit
--- @field NORMAL my.edit.NORMAL
--- @field ['n'] my.edit.NORMAL
--- @field COMMAND my.edit.COMMAND
--- @field ['c'] my.edit.COMMAND
--- @field INSERT my.edit.INSERT
--- @field ['i'] my.edit.INSERT
local M = my.util.defer_require("my.edit", {
  NORMAL = ..., --- @module 'my.edit.NORMAL'
  ["n"] = "NORMAL",
  COMMAND = ..., --- @module 'my.edit.COMMAND'
  ["c"] = "COMMAND",
  INSERT = ..., --- @module 'my.edit.INSERT'
  ["i"] = "INSERT",
})

--- neovim multicursor cascade 不合理, 真心不好用

local function set_cursor(cursor, offset)
  if cursor[1] ~= -1 then
    vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, cursor[2] + offset, cursor[3], { id = cursor[1] })
  else
    vim.api.nvim_win_set_cursor(0, { cursor[2] + 1 + offset, cursor[3] })
  end
end

--- @class my.edit.add_blank_line.Opts
--- @field follow? boolean default false

--- @param count integer
--- @param opts? my.edit.add_blank_line.Opts
function M.add_blank_line(count, opts)
  vim.validate("count", count, "number")
  vim.validate("opts", opts, "table", true)
  count = math.floor(count)
  if count == 0 then
    return
  end
  opts = opts or {}
  vim.validate("opts.follow", opts.follow, "boolean", true)
  if vim.v.cascading then
    return
  end
  local follow = opts.follow
  local above = count < 0
  count = math.abs(count)
  local multicursors = my.multicursor.get(0, 0, -1)
  local cursor = vim.api.nvim_win_get_cursor(0)
  table.insert(multicursors, { -1, cursor[1] - 1, cursor[2] })
  -- stylua: ignore
  table.sort(multicursors, function(a, b) return a[2] > b[2] end)
  local offset = above and -1 or 0
  for _, cs in ipairs(multicursors) do
    local start = cs[2] + 1
    local end_ = start
    local blank_lines = vim.fn["repeat"]({ "" }, count)
    cs[3] = follow and cs[3] or 0
    vim.api.nvim_buf_set_lines(0, start + offset, end_ + offset, false, blank_lines)
  end
  for i, cs in ipairs(multicursors) do
    if above then
      if follow then
        set_cursor(cs, (#multicursors - i + 1) * count)
      else
        set_cursor(cs, (#multicursors - i) * count)
      end
    else
      if follow then
        set_cursor(cs, (#multicursors - i) * count)
      else
        set_cursor(cs, (#multicursors - i + 1) * count)
      end
    end
  end
end

function M.below_add_blank_line()
  M.add_blank_line(vim.v.count1, { follow = false })
end

function M.below_add_blank_line_follow()
  M.add_blank_line(vim.v.count1, { follow = true })
end

function M.above_add_blank_line()
  M.add_blank_line(-vim.v.count1, { follow = false })
end

function M.above_add_blank_line_follow()
  M.add_blank_line(-vim.v.count1, { follow = true })
end

function M.above_below_add_blank_line()
  M.above_add_blank_line_follow()
  M.below_add_blank_line_follow()
end

function M.trim_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1]
  local line = vim.api.nvim_get_current_line()
  local col = line:find("%S") or #line + 1
  col = col - 1
  line = vim.trim(line)
  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { line })
  vim.api.nvim_win_set_cursor(0, { lnum, math.max(cursor[2] - col, 1) })
end

--- @param WORD boolean|nil
local function trim_cword_trail(WORD)
  local pattern = WORD and [[\S\+]] or [[\(\%(\%(\k\)\@!\S\)\+\)\|\(\k\+\)]]
  local cursor = vim.api.nvim_win_get_cursor(0)
  local matches = my.buf_match(0, pattern, cursor, { count = 2 })
  if #matches < 2 then
    return
  end
  if matches[1].col > cursor[2] then
    return
  end
  local cword_match = matches[1]
  local nword_match = matches[2]
  if cword_match.end_col == nword_match.col then
    return
  end
  if cword_match.lnum == nword_match.lnum then
    local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
    local left_part = line:sub(1, cword_match.end_col)
    local right_part = line:sub(nword_match.col + 1)
    vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { left_part .. right_part })
  else
    local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
    local new_line = line:sub(1, cword_match.end_col)
    vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { new_line })
  end
end

--- @param WORD boolean|nil
local function trim_cword_lead(WORD)
  local pattern = WORD and [[\S\+]] or [[\(\%(\%(\k\)\@!\S\)\+\)\|\(\k\+\)]]
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start = { cursor[1], cursor[2] }
  if WORD and my.cursor.at_WORD_start() or my.cursor.at_word_start() then
    start[2] = start[2] + 1
  end
  local matches = my.buf_match(0, pattern, start, { count = 2, backward = true })
  if #matches < 2 then
    return
  end
  if matches[1].end_col < cursor[2] then
    return
  end
  local cword_match = matches[1]
  local nword_match = matches[2]
  if cword_match.col == nword_match.end_col then
    return
  end
  if cword_match.lnum == nword_match.lnum then
    local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
    local new_line = line:sub(1, nword_match.end_col) .. line:sub(cword_match.col + 1)
    vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { new_line })
    cursor[2] = cursor[2] + #new_line - #line
  else
    local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
    local new_line = line:sub(cword_match.col + 1)
    cursor[2] = cursor[2] + #new_line - #line
    vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { new_line })
  end
  vim.api.nvim_win_set_cursor(0, cursor)
end

function M.trim_cword_trail()
  trim_cword_trail()
end

function M.trim_cWORD_trail()
  trim_cword_trail(true)
end

function M.trim_cword_lead()
  trim_cword_lead()
end

function M.trim_cWORD_lead()
  trim_cword_lead(true)
end

function M.trim_cword() end

return M
