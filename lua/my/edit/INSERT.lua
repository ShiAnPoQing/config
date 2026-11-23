--- @class my.edit.INSERT
local M = {}

do
  --- @param cWORD boolean|nil
  --- @param backward boolean|nil
  local function delete_cword(cWORD, backward)
    local pattern = cWORD and [[\(\s\+\)\|\(\S\+\)]] or [[\(\%(\%(\k\)\@!\S\)\+\)\|\(\k\+\)\|\(\s\+\)]]
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cword_match =
      my.buf.match(0, cursor, pattern, { count = backward and -1 or 1, strict = false, start_kind = "boundary" })[1]
    if not cword_match then
      return
    end
    local lnum = cword_match.row
    if lnum > cursor[1] then
      local start = cursor[1] - 1
      local end_ = lnum
      local lines = vim.api.nvim_buf_get_lines(0, start, end_, true)
      local new_line = lines[1] .. lines[2]:sub(1, cword_match.col) .. lines[2]:sub(cword_match.end_col + 1)
      vim.api.nvim_buf_set_lines(0, start, end_, true, { new_line })
      vim.api.nvim_win_set_cursor(0, { cursor[1], cword_match.col + #lines[1] })
    else
      local start = lnum - 1
      local end_ = cursor[1]
      local lines = vim.api.nvim_buf_get_lines(0, start, end_, true)
      local new_line = lines[1]:sub(1, cword_match.col) .. lines[1]:sub(cword_match.end_col + 1) .. (lines[2] or "")
      vim.api.nvim_buf_set_lines(0, start, end_, true, { new_line })
      vim.api.nvim_win_set_cursor(0, { lnum, cword_match.col })
    end
  end

  --- @param backward boolean?
  function M.delete_cword(backward)
    delete_cword(false, backward)
  end

  --- @param backward boolean?
  function M.delete_cWORD(backward)
    delete_cword(true, backward)
  end
end

return M
