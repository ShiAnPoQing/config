local S = require("builtin.cmdline.shared")
local word_regex = vim.regex("\\k\\+\\|[^[:keyword:][:space:]]\\+")
local WORD_regex = vim.regex("\\S\\+")
local cword_regex = vim.regex("\\k\\+\\|[^[:keyword:][:space:]]\\+\\|\\s\\+")
local CWORD_regex = vim.regex("\\S\\+\\|\\s\\+")

local M = {}

local function match(regex, str, callback)
  local function run(s)
    local start, _end = regex:match_str(s)
    if start == nil then
      return
    end
    if callback(#str - #s + start, #str - #s + _end) then
      return
    end
    run(s:sub(_end + 1))
  end

  run(str)
end

local function get_new_cmdpos(regex, cmdline, callback)
  local new_cmdpos
  match(regex, cmdline, function(start, _end)
    local may_new_cmdpos, is_finished = callback(start + 1, _end)
    if type(may_new_cmdpos) == "number" then
      new_cmdpos = may_new_cmdpos
    end
    return is_finished
  end)
  return new_cmdpos
end

local function get_cword_pos(regex, cmdline, callback)
  local cword_pos
  match(regex, cmdline, function(start, _end)
    local may_cword_pos, is_finished = callback(start + 1, _end)
    if type(may_cword_pos) == "table" then
      cword_pos = may_cword_pos
    end
    return is_finished
  end)
  return cword_pos
end

local function get_CWORD_pos(regex, cmdline, callback)
  local cword_pos
  match(regex, cmdline, function(start, _end)
    local may_cword_pos, is_finished = callback(start + 1, _end)
    if type(may_cword_pos) == "table" then
      cword_pos = may_cword_pos
    end
    return is_finished
  end)
  return cword_pos
end

function M.next_word_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
    if cmdpos <= _end then
      return _end + 1, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline + 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.next_word_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
    if cmdpos < start then
      return start, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline + 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.prev_word_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
    if cmdpos > start then
      return start
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.prev_word_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
    if cmdpos > _end + 1 then
      return _end + 1
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.delete_to_next_word_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
    if cmdpos < start then
      return start, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline
  end
  local new_cmdline = cmdline:sub(1, cmdpos - 1) .. cmdline:sub(new_cmdpos)
  vim.fn.setcmdline(new_cmdline, cmdpos)
end

function M.delete_to_next_word_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
    if cmdpos <= _end then
      return _end + 1, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline
  end
  local new_cmdline = cmdline:sub(1, cmdpos - 1) .. cmdline:sub(new_cmdpos)
  vim.fn.setcmdline(new_cmdline, cmdpos)
end

function M.delete_to_prev_word_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
    if cmdpos > start then
      return start
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  local new_cmdline = cmdline:sub(1, new_cmdpos - 1) .. cmdline:sub(cmdpos)
  vim.fn.setcmdline(new_cmdline, new_cmdpos)
end

function M.delete_to_prev_word_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
    if cmdpos > _end + 1 then
      return _end + 1
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  local new_cmdline = cmdline:sub(1, new_cmdpos - 1) .. cmdline:sub(cmdpos)
  vim.fn.setcmdline(new_cmdline, new_cmdpos)
end

function M.delete_cword_before()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local next_word_pos
  local cword_pos = get_cword_pos(cword_regex, cmdline, function(start, _end)
    if cmdpos > start then
      return {
        start = start,
        _end = _end,
      }
    end
    if cmdpos == start then
      next_word_pos = {
        start = start,
        _end = _end,
      }
    end
  end)
  cword_pos = cword_pos or next_word_pos
  if not cword_pos then
    return
  end
  local before_cword = cmdline:sub(1, cword_pos.start - 1)
  local after_cword = cmdline:sub(cword_pos._end + 1)
  local new_cmdline = before_cword .. after_cword
  vim.fn.setcmdline(new_cmdline, #before_cword + 1)
end

function M.delete_cword_after()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local prev_word_pos
  local cword_pos = get_cword_pos(cword_regex, cmdline, function(start, _end)
    if cmdpos > start then
      prev_word_pos = {
        start = start,
        _end = _end,
      }
    end
    if cmdpos >= start then
      return {
        start = start,
        _end = _end,
      }
    end
  end)
  cword_pos = cword_pos or prev_word_pos
  if not cword_pos then
    return
  end
  local before_cword = cmdline:sub(1, cword_pos.start - 1)
  local after_cword = cmdline:sub(cword_pos._end + 1)
  local new_cmdline = before_cword .. after_cword
  vim.fn.setcmdline(new_cmdline, #before_cword + 1)
end

function M.next_WORD_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(start, _)
    if cmdpos < start then
      return start, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline + 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.next_WORD_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(_, _end)
    if cmdpos <= _end then
      return _end + 1, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline + 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.prev_WORD_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(start, _)
    if cmdpos > start then
      return start
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.prev_WORD_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(_, _end)
    if cmdpos > _end + 1 then
      return _end + 1
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  vim.fn.setcmdline(cmdline, new_cmdpos)
end

function M.delete_to_next_WORD_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(start, _)
    if cmdpos < start then
      return start, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline
  end
  local new_cmdline = cmdline:sub(1, cmdpos - 1) .. cmdline:sub(new_cmdpos)
  vim.fn.setcmdline(new_cmdline, cmdpos)
end

function M.delete_to_next_WORD_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(_, _end)
    if cmdpos <= _end then
      return _end + 1, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline
  end
  local new_cmdline = cmdline:sub(1, cmdpos - 1) .. cmdline:sub(new_cmdpos)
  vim.fn.setcmdline(new_cmdline, cmdpos)
end

function M.delete_to_prev_WORD_start()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(start, _)
    if cmdpos > start then
      return start
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  local new_cmdline = cmdline:sub(1, new_cmdpos - 1) .. cmdline:sub(cmdpos)
  vim.fn.setcmdline(new_cmdline, new_cmdpos)
end

function M.delete_to_prev_WORD_end()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(_, _end)
    if cmdpos > _end + 1 then
      return _end + 1
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  local new_cmdline = cmdline:sub(1, new_cmdpos - 1) .. cmdline:sub(cmdpos)
  vim.fn.setcmdline(new_cmdline, new_cmdpos)
end

function M.delete_CWORD_before()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local next_word_pos
  local CWORD_pos = get_CWORD_pos(CWORD_regex, cmdline, function(start, _end)
    if cmdpos > start then
      return {
        start = start,
        _end = _end,
      }
    end
    if cmdpos == start then
      next_word_pos = {
        start = start,
        _end = _end,
      }
    end
  end)
  CWORD_pos = CWORD_pos or next_word_pos
  if not CWORD_pos then
    return
  end
  local before_cword = cmdline:sub(1, CWORD_pos.start - 1)
  local after_cword = cmdline:sub(CWORD_pos._end + 1)
  local new_cmdline = before_cword .. after_cword
  vim.fn.setcmdline(new_cmdline, #before_cword + 1)
end

function M.delete_CWORD_after()
  local cmdline, cmdpos = S.get_cmdline_and_cmdpos()
  local prev_word_pos
  local CWORD_pos = get_CWORD_pos(CWORD_regex, cmdline, function(start, _end)
    if cmdpos > start then
      prev_word_pos = {
        start = start,
        _end = _end,
      }
    end
    if cmdpos >= start then
      return {
        start = start,
        _end = _end,
      }
    end
  end)
  CWORD_pos = CWORD_pos or prev_word_pos
  if not CWORD_pos then
    return
  end
  local before_cword = cmdline:sub(1, CWORD_pos.start - 1)
  local after_cword = cmdline:sub(CWORD_pos._end + 1)
  local new_cmdline = before_cword .. after_cword
  vim.fn.setcmdline(new_cmdline, #before_cword + 1)
end

return M
