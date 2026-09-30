--- @class my.cursor
local M = vim._defer_require("my.cursor", {})

function M.is_word_end()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local word = vim.fn.matchstrpos(line, [[\k\+]], col)
  local start = word[2]
  local end_ = word[3]
  if start ~= -1 then
    if start == col and end_ == start + 1 then
      return true
    end
  end
end

function M.is_word_start()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local r_line = vim.api.nvim_get_current_line():reverse()

  local word = vim.fn.matchstrpos(r_line, [[\k\+]], #r_line - col - 1)
  local start = word[2]
  local end_ = word[3]
  if start ~= -1 then
    local _start = #r_line - start - 1
    local _end_ = #r_line - end_ + 1
    if _start == col and _end_ == _start + 1 then
      return true
    end
  end
end

return M
