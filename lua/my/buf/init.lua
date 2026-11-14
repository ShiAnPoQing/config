--- @class my.buf
--- @field [integer] any
local M = {}

setmetatable(M, {
  __index = function(_, k)
    if type(k) == "number" then
      return setmetatable({}, {
        __index = function(_, key)
          if type(M[key]) == "function" then
            return function(...)
              return M[key](k, ...)
            end
          end
        end,
      })
    end
  end,
})

--- @param buf integer
--- @param start integer
--- @param end_ integer
function M.trim_lines(buf, start, end_)
  vim.validate("buf", buf, "number")
  vim.validate("start", start, "number")
  vim.validate("end_", end_, "number")
  if not vim.api.nvim_buf_is_valid(buf) then
    vim.notify(string.format("my.buf[%d]: Buffer %d doest not exist", buf), vim.log.levels.ERROR)
    return
  end
  start = math.floor(start)
  end_ = math.floor(end_)
  local cur_buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, start, end_, false)
  local cursor
  if cur_buf == buf or buf == 0 then
    cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = vim.api.nvim_get_current_line()
    local col = current_line:find("%S") or #current_line + 1
    col = col - 1
    cursor[2] = math.max(cursor[2] - col, 1)
  end
  local new_lines = {}
  for _, line in ipairs(lines) do
    new_lines[#new_lines + 1] = vim.trim(line)
  end
  vim.api.nvim_buf_set_lines(0, start, end_, false, new_lines)
  if cursor then
    vim.api.nvim_win_set_cursor(0, cursor)
  end
end

return M
