--- @class my._buf
--- @field trim_lines fun(start: integer, end_:integer, opts: my.buf.trim_lines.Opts)
--- @field match fun(start: [integer, integer], pattern: integer, opts: my.buf.match.Opts): my.buf.Match[]

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

do
  --- @param buf integer
  --- @param start_row integer
  --- @param start_col integer
  local function buf_validate_position(buf, start_row, start_col)
    if start_row <= 0 or start_row > vim.api.nvim_buf_line_count(buf) then
      vim.notify("my.buf.find_next_match: start_row out of buf", vim.log.levels.ERROR)
      return
    end
    if start_col < 0 or start_col > #vim.api.nvim_buf_get_lines(buf, start_row - 1, start_row, true)[1] then
      vim.notify("my.buf.find_next_match: start_col out of buf", vim.log.levels.ERROR)
      return
    end
  end

  --- @param count any
  --- @return integer
  local function normalize_count(count)
    return math.floor(type(count) == "number" and count or 1)
  end

  local function validate_start_kind(kind)
    if type(kind) ~= "string" then
      vim.notify(
        string.format('my.buf.match: "opts.start_kind" must be one of "char"|"boundary", but got type %s', type(kind)),
        vim.log.levels.ERROR
      )
    end
    if not vim.list_contains({ "char", "boundary" }, kind) then
      vim.notify(
        string.format('my.buf.match: "opts.start_kind" must be one of "char"|"boundary", but got %s', kind),
        vim.log.levels.ERROR
      )
    end
  end

  --- @class my.buf.match.Opts
  --- @field strict? boolean default true
  --- @field count? integer default 1
  --- @field start_kind? "char"|"boundary" default "char"

  --- @class my.buf.Match
  --- @field row integer 1-based
  --- @field col integer 0-based
  --- @field end_row integer
  --- @field end_col integer
  --- @field text string

  --- 在 buffer 中按 Vim pattern 查找匹配，从 start 位置字符开始，返回长度最多 count 的匹配数组
  ---
  --- @param buf integer Buffer id, or `0` for current buffer
  --- @param start [integer, integer] 匹配起始位置 `(1, 0)-based`
  --- see `my.buf.match.Opts.start_kind`
  --- @param pattern string Vim pattern
  --- @param opts? my.buf.match.Opts Optional parameters:
  --- - count: (integer, default: 1) 指定匹配的方向与至多返回的匹配数，
  --- 正数代表向前匹配,
  --- 负数代表向后匹配,
  --- 0 代表仅匹配起始字符所在的 match，至多返回一个匹配数
  --- - strict: (boolean, default: true)
  --- - start_kind: ("char"|"boundary", default: "char") 决定 start 位置类型
  ---     - "char" 代表 start 是字符位置
  ---     - "boundary" 代表 start 是字符边界位置
  --- @return my.buf.Match[] # 无匹配时返回空数组
  --- - row: (integer) 匹配的起始 row 1-based
  --- - col: (integer) 匹配的起始 col 0-based start_inclusive
  --- - end_row: (integer) 匹配的结束 row 1-based
  --- - end_col: (integer) 匹配的结束 col 0-based end-exclusive
  --- - text: (string) 匹配的文本
  function M.match(buf, start, pattern, opts)
    vim.validate("buf", buf, "number")
    vim.validate("start", start, "table")
    vim.validate("start[1]", start[1], "number")
    vim.validate("start[2]", start[2], "number")
    vim.validate("pattern", pattern, "string")
    vim.validate("opts", opts, "table", true)
    opts = opts or {}
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
    local start_row = math.floor(start[1])
    local start_col = math.floor(start[2])
    buf_validate_position(buf, start_row, start_col)
    --- @type  my.buf.Match[]
    local matches = {}
    local count = normalize_count(opts.count)
    local backward = count < 0
    count = math.abs(count)
    local strict = opts.strict ~= false
    local start_kind = opts.start_kind and opts.start_kind or "char"
    validate_start_kind(start_kind)
    local _start_col
    if start_kind == "boundary" then
      _start_col = start_col - 1
    else
      _start_col = start_col
    end
    local ctx = {
      is_done = function()
        return #matches == count
      end,
    }
    if backward then
      ctx.step = -1
      ctx.end_lnum = 1
      ctx.is_target_match = function(line, item)
        local col = item.byteidx
        local end_col = col + #item.text
        return (line == start_row and ((strict and end_col <= start_col) or (not strict and col <= _start_col)))
          or line ~= start_row
      end
    else
      ctx.step = 1
      if count == 0 then
        ctx.is_done = function(line, item)
          if #matches == 1 then
            return true
          end
          if (line == start_row and item.byteidx > start_col) or line ~= start_row then
            return true
          end
        end
        ctx.is_target_match = function(line, item)
          local col = item.byteidx
          local end_col = col + #item.text
          return line == start_row and col <= _start_col and end_col > start_col
        end
        ctx.end_lnum = start_row
      else
        ctx.is_target_match = function(line, item)
          local col = item.byteidx
          local end_col = col + #item.text
          return (line == start_row and ((strict and col >= _start_col) or (not strict and end_col > start_col)))
            or line ~= start_row
        end
        ctx.end_lnum = vim.api.nvim_buf_line_count(buf)
      end
    end

    --- @param lnum integer
    local function match(lnum)
      local step = ctx.step
      local end_lnum = ctx.end_lnum
      local is_target_match = ctx.is_target_match
      if (step > 0 and lnum > end_lnum) or (step < 0 and lnum < end_lnum) then
        return
      end

      --- @type any[]
      local list = vim.fn.matchbufline(buf, pattern, lnum, lnum)
      if step < 0 then
        --- @diagnostic disable-next-line: undefined-field
        list = vim.iter(list):rev():totable()
      end
      for _, item in ipairs(list) do
        if is_target_match(lnum, item) then
          matches[#matches + 1] = {
            col = item.byteidx,
            row = lnum,
            end_col = item.byteidx + #item.text,
            end_row = lnum,
            text = item.text,
          }
        end
        if ctx.is_done(lnum, item) then
          return
        end
      end
      match(lnum + step)
    end

    match(start_row)
    return matches
  end
end

return M
