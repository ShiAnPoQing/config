--- @class my.cursor
local M = vim._defer_require("my.cursor", {})
local word_pattern = [[\(\%(\%(\k\)\@!\S\)\+\)\|\(\k\+\)]]
local WORD_pattern = [[\S\+]]

--- @param pattern string
--- @return boolean
function M.at_match_start(pattern)
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local r_line = vim.api.nvim_get_current_line():reverse()

  local word = vim.fn.matchstrpos(r_line, pattern, #r_line - col - 1)
  local start = word[2]
  local end_ = word[3]
  if start ~= -1 then
    local _start = #r_line - start - 1
    local _end_ = #r_line - end_ + 1
    if _start == col and _end_ == _start + 1 then
      return true
    end
  end
  return false
end

--- @param pattern string
--- @return boolean
function M.at_match_end(pattern)
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local word = vim.fn.matchstrpos(line, pattern, col)
  local start = word[2]
  local end_ = word[3]
  if start ~= -1 then
    if start == col and end_ == start + 1 then
      return true
    end
  end
  return false
end

--- @param pattern string
--- @return boolean
function M.at_match(pattern)
  local col = vim.fn.col(".")
  local word = vim.fn.matchstrpos(vim.api.nvim_get_current_line(), pattern, col - 1)
  local start = word[2]
  if start == -1 then
    return false
  end
  if start == col - 1 then
    return true
  end
  return false
end

function M.at_word_start()
  return M.at_match_start(word_pattern)
end

function M.at_word_end()
  return M.at_match_end(word_pattern)
end

function M.at_WORD_start()
  return M.at_match_start(WORD_pattern)
end

function M.at_WORD_end()
  return M.at_match_end(WORD_pattern)
end

function M.at_word()
  return M.at_match(word_pattern)
end

function M.at_WORD()
  return M.at_match(WORD_pattern)
end

--- @param pattern string
--- @return table|nil
function M.match_next(pattern)
  local topline, start_col = unpack(vim.api.nvim_win_get_cursor(0))
  local regex = vim.regex(pattern)
  local botline = vim.api.nvim_buf_line_count(0)

  local target_match_idx = M.at_match(pattern) and 2 or 1
  local matchs = {}
  for i = topline, botline do
    local start_pos = (i == topline) and start_col or 0
    while true do
      local start, end_ = regex:match_line(0, i - 1, start_pos)
      if not start or not end_ or (start == 0 and end_ == 0) then
        break
      else
        table.insert(matchs, { line = i, col = start + start_pos, end_col = end_ + start_pos })
        if #matchs == target_match_idx then
          break
        end
      end
      start_pos = start_pos + end_
    end
    if #matchs == target_match_idx then
      break
    end
  end
  return matchs[target_match_idx]
end

--- @param pattern string
--- @return table|nil
function M.match_prev(pattern)
  local regex = vim.regex(pattern)
  local is_in_word = M.at_match(pattern)
  local topline = 1
  local botline, end_col = unpack(vim.api.nvim_win_get_cursor(0))
  local match
  for i = botline, topline, -1 do
    local is_cursor_line = i == botline
    local start_pos = 0
    local line_matchs = {}
    while true do
      local start, end_

      if is_cursor_line then
        local line = vim.api.nvim_get_current_line()
        if end_col < #line then
          start, end_ = regex:match_line(0, i - 1, start_pos, end_col + 1)
        end
      else
        start, end_ = regex:match_line(0, i - 1, start_pos)
      end

      if not start or not end_ or (start == 0 and end_ == 0) then
        break
      else
        table.insert(line_matchs, { line = i, col = start + start_pos, end_col = end_ + start_pos })
      end

      start_pos = start_pos + end_
    end

    if is_in_word and is_cursor_line then
      table.remove(line_matchs, #line_matchs)
    end

    if #line_matchs > 0 then
      match = line_matchs[#line_matchs]
      break
    end
  end
  return match
end

function M.match_prev_word()
  return M.match_prev(word_pattern)
end

function M.match_next_word()
  return M.match_next(word_pattern)
end

function M.match_next_WORD()
  return M.match_next(WORD_pattern)
end

function M.match_prev_WORD()
  return M.match_prev(WORD_pattern)
end

-- function M.get_cword_pos()
--   local _, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local line = vim.api.nvim_get_current_line()
--   local word = vim.fn.matchstrpos(line, [[\k\+]], col)
--   local start = word[2]
--   local end_ = word[3]
--   if start ~= -1 then
--     if start == col and end_ == start + 1 then
--       return true
--     end
--   end
-- end

return M
