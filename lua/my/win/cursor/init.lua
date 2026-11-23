--- @class my._win.cursor
--- @field at_match fun(pattern: string): boolean
--- @field at_match_start fun(pattern: string): boolean
--- @field at_match_end fun(pattern: string): boolean
--- @field at_word fun(): boolean
--- @field at_word_start fun(): boolean
--- @field at_word_end fun(): boolean
--- @field at_WORD fun(): boolean
--- @field at_WORD_start fun(): boolean
--- @field at_WORD_end fun(): boolean
--- @field match fun(pattern: string, opts?: my.buf.match.Opts): my.buf.Match[]
--- @field match_word fun(opts?: my.buf.match.Opts): my.buf.Match[]
--- @field match_WORD fun(opts?: my.buf.match.Opts): my.buf.Match[]
--- @field match_cword fun(): my.buf.Match|nil
--- @field match_cWORD fun(): my.buf.Match|nil

--- @class my.win.cursor
local M = my.module.defer_require("my.win.cursor", {
  motion = {
    scope = true,
  },
})

--- @param win integer
--- @param pattern string
--- @return boolean
function M.at_match(win, pattern)
  vim.validate("win", win, "number")
  vim.validate("pattern", pattern, "string")
  return vim.api.nvim_win_call(win, function()
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
  end)
end

--- @param win integer
--- @param pattern string
--- @return boolean
function M.at_match_start(win, pattern)
  vim.validate("win", win, "number")
  vim.validate("pattern", pattern, "string")
  return vim.api.nvim_win_call(win, function()
    local _, col = unpack(vim.api.nvim_win_get_cursor(win))
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
  end)
end

--- @param win integer
--- @param pattern string
--- @return boolean
function M.at_match_end(win, pattern)
  vim.validate("win", win, "number")
  vim.validate("pattern", pattern, "string")
  return vim.api.nvim_win_call(win, function()
    local _, col = unpack(vim.api.nvim_win_get_cursor(win))
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
  end)
end

local word_pattern = [[\(\%(\%(\k\)\@!\S\)\+\)\|\(\k\+\)]]
local WORD_pattern = [[\S\+]]

--- @param win integer
--- @return boolean
function M.at_word(win)
  return M.at_match(win, word_pattern)
end

--- @param win integer
--- @return boolean
function M.at_word_start(win)
  return M.at_match_start(win, word_pattern)
end

--- @param win integer
--- @return boolean
function M.at_word_end(win)
  return M.at_match_end(win, word_pattern)
end

--- @param win integer
--- @return boolean
function M.at_WORD(win)
  return M.at_match(win, WORD_pattern)
end

--- @param win integer
--- @return boolean
function M.at_WORD_start(win)
  return M.at_match_start(win, WORD_pattern)
end

--- @param win integer
--- @return boolean
function M.at_WORD_end(win)
  return M.at_match_end(win, WORD_pattern)
end

--- @param win integer
--- @param pattern string
--- @param opts? my.buf.match.Opts
--- @return my.buf.Match[]
function M.match(win, pattern, opts)
  vim.validate("win", win, "number")
  return my.buf.match(vim.api.nvim_win_get_buf(win), vim.api.nvim_win_get_cursor(win), pattern, opts)
end

--- @param win integer
--- @param opts? my.buf.match.Opts
--- @return my.buf.Match[]
function M.match_word(win, opts)
  return M.match(win, word_pattern, opts)
end

--- @param win integer
--- @param opts? my.buf.match.Opts
--- @return my.buf.Match[]
function M.match_WORD(win, opts)
  return M.match(win, WORD_pattern, opts)
end

--- @param win integer
function M.match_cword(win)
  return M.match(win, word_pattern, { count = 0 })[1]
end

--- @param win integer
function M.match_cWORD(win)
  return M.match(win, WORD_pattern, { count = 0 })[1]
end

return M
