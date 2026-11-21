--- @class my._buf
--- @field trim_lines fun(start: integer, end_:integer, opts: my.buf.trim_lines.Opts)

local submodules = {}

--- @class my.buf
--- @field [integer] my._buf
local M = { _submodules = submodules }

setmetatable(M, {
  __index = function(t, k)
    if type(k) == "number" then
      local buf = k
      if not vim.api.nvim_buf_is_valid(buf) then
        vim.notify(string.format("my.buf[%d]: Invalid buf", buf), vim.log.levels.ERROR)
        return nil
      end
      vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        callback = function()
          t[k] = nil
          return true
        end,
        buf = buf,
      })
      t[k] = my.module.wrap_with_scope(buf, M)
      return t[k]
    end
    if not submodules[k] then
      return
    end
    local name = string.format("%s.%s", "my.buf", k)
    t[k] = require(name)
    return t[k]
  end,
})

do
  --- @param buf integer
  --- @param start integer
  --- @param end_ integer
  --- @param trim_trail boolean
  --- @param trim_lead boolean
  local function compute_new_cursor(buf, start, end_, trim_trail, trim_lead)
    local cur_buf = vim.api.nvim_get_current_buf()
    if buf ~= 0 and cur_buf ~= buf then
      return
    end
    local buf_line_count = vim.api.nvim_buf_line_count(buf)
    local _start = start < 0 and buf_line_count + 1 + start or start
    local _end = end_ < 0 and buf_line_count + 1 + end_ or end_
    local cursor = vim.api.nvim_win_get_cursor(0)
    if not (_start + 1 <= cursor[1] and _end + 1 > cursor[1]) then
      return
    end
    local cur_line = vim.api.nvim_get_current_line()
    if trim_trail then
      local col = cur_line:reverse():find("%S") or 0
      col = #cur_line - col
      cursor[2] = math.min(cursor[2], col)
    end
    if trim_lead then
      local col = cur_line:find("%S") or #cur_line + 1
      col = col - 1
      cursor[2] = math.max(cursor[2] - col, 0)
    end
    return cursor
  end
  --- @class my.buf.trim_lines.Opts
  --- @field mode? "lead"|"trail"|("lead"|"trail")[] default { "lead", "trail" }

  --- @param buf integer
  --- @param start integer
  --- @param end_ integer
  --- @param opts? my.buf.trim_lines.Opts
  function M.trim_lines(buf, start, end_, opts)
    vim.validate("buf", buf, "number")
    vim.validate("start", start, "number")
    vim.validate("end_", end_, "number")
    vim.validate("opts", opts, "table", true)
    opts = opts or {}
    if not vim.api.nvim_buf_is_valid(buf) then
      vim.notify(string.format("my.buf[%d]: Buffer %d doest not exist", buf, buf), vim.log.levels.ERROR)
      return
    end
    start = math.floor(start)
    end_ = math.floor(end_)
    vim.validate("opts.mode", opts.mode, { "string", "table" }, true)
    local mode = opts.mode or { "lead", "trail" }
    if type(mode) == "string" then
      mode = { mode }
    end
    local trim_lead = vim.list_contains(mode, "lead")
    local trim_trail = vim.list_contains(mode, "trail")
    local lines = vim.api.nvim_buf_get_lines(buf, start, end_, false)
    local cursor = compute_new_cursor(buf, start, end_, trim_trail, trim_lead)
    local new_lines = {}
    for _, line in ipairs(lines) do
      local new_line
      if trim_lead and trim_trail then
        new_line = vim.trim(line)
      elseif trim_lead then
        new_line = vim.fn.trim(line, "", 1)
      elseif trim_trail then
        new_line = vim.fn.trim(line, "", 2)
      end
      new_lines[#new_lines + 1] = new_line
    end
    vim.api.nvim_buf_set_lines(buf, start, end_, false, new_lines)
    if cursor then
      vim.api.nvim_win_set_cursor(0, cursor)
    end
  end
end

return M
