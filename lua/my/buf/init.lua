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

do
  local function notify_error(formatstr, ...)
    vim.notify(string.format("my.buf.list: " .. formatstr, ...), vim.log.levels.ERROR)
  end

  local function normalize_filter(filter)
    if not filter then
      return
    end

    if type(filter) == "function" then
      return { filter = filter, pattern = {} }
    end

    if type(filter.mode) ~= "string" then
      notify_error('"filter.mode" expected one of "filetype"|"glob"|"regex", but got type %s', type(filter.mode))
      return
    end

    if not vim.list_contains({ "filetype", "glob", "regex" }, filter.mode) then
      notify_error('"filter.mode" expected one of "filetype"|"glob"|"regex", but got %s', filter.mode)
      return
    end

    local pattern = filter.pattern
    local pattern_type = type(pattern)
    if pattern_type == "table" then
    elseif type(pattern_type) == "string" then
      filter.pattern = { pattern }
    else
      notify_error('"filter.pattern" expected string|string[], but got type %s', type(pattern))
      return
    end

    local filter_func = filter.filter
    if filter_func and type(filter_func) ~= "function" then
      notify_error('"filter.filter" expected function, but got type %s', type(filter_func))
      return
    end

    return filter
  end

  local function get_filter_func(filter)
    if not filter then
      return function()
        return true
      end
    end
    local filterfunc

    local mode = filter.mode
    local patterns = filter.pattern
    if mode == "filetype" then
      filterfunc = function(buf, name)
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf, scope = "local" })
        if not vim.list_contains(patterns, ft) then
          return false
        end
        if not filter.filter then
          return true
        end
        return filter.filter({ buf = buf, name = name, filetype = ft, mode = mode, pattern = patterns })
      end
    elseif mode == "glob" then
      local lpegs = {}
      for _, pattern in ipairs(patterns) do
        lpegs[#lpegs + 1] = vim.glob.to_lpeg(pattern)
      end
      filterfunc = function(buf, name)
        local short_name = vim.fn.fnamemodify(name, ":t")
        for _, lpeg in ipairs(lpegs) do
          if lpeg:match(short_name) then
            if not filter.filter then
              return true
            end
            return filter.filter({ buf = buf, name = name, mode = mode, pattern = patterns })
          end
        end
        return false
      end
    elseif mode == "regex" then
      local regexs = {}
      for _, pattern in ipairs(patterns) do
        regexs[#regexs + 1] = vim.regex(pattern)
      end
      filterfunc = function(buf, name)
        for _, regex in ipairs(regexs) do
          if not vim.startswith(name, "term://") and regex:match_str(name) then
            if not filter.filter then
              return true
            end
            return filter.filter({ buf = buf, name = name, mode = mode, pattern = patterns })
          end
        end
        return false
      end
    elseif not mode then
      filterfunc = function(buf, name)
        return filter.filter({ buf = buf, name = name })
      end
    end
    return filterfunc
  end

  local function get_buf_items(opts)
    local filterfunc = get_filter_func(normalize_filter(opts.filter))
    local listed = opts.listed ~= false
    local items = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      local buflisted = vim.api.nvim_get_option_value("buflisted", { scope = "local", buf = buf })
      if listed and not buflisted then
        goto next
      end
      local filter = filterfunc(buf, name)
      if filter then
        table.insert(items, {
          buf = buf,
          name = name,
        })
      end
      ::next::
    end
    return items
  end

  local function format_items(items)
    local new_items = {}
    for _, item in ipairs(items) do
      local a = vim.api.nvim_buf_get_mark(item.buf, '"')[1]
      new_items[#new_items + 1] =
        string.format('  %d   "%s"  line %d', item.buf, vim.fn.fnamemodify(item.name, ":~:."), a)
    end
    return new_items
  end

  --- @alias my.buf.list.Opts.Filter.Mode "filetype"|"glob"|"regex"

  --- @class my.buf.list.Opts.FilterContext
  --- @field buf integer
  --- @field name string

  --- @class my.buf.list.Opts.Filter.FilterContext: my.buf.list.Opts.FilterContext
  --- @field pattern string[]
  --- @field mode my.buf.list.Opts.Filter.Mode
  --- @field filetype? string

  --- @class my.buf.list.Opts.Filter
  --- @field pattern? string|string[]
  --- @field mode my.buf.list.Opts.Filter.Mode
  --- @field filter? fun(ctx: my.buf.list.Opts.Filter.FilterContext): boolean|nil

  --- @class my.buf.list.Opts
  --- @field filter? my.buf.list.Opts.Filter|fun(ctx: my.buf.list.Opts.FilterContext): boolean|nil
  --- @field listed? boolean

  --- @param opts? my.buf.list.Opts Optional parameters:
  --- - filter?: `my.buf.list.Opts.Filter|fun(ctx: my.buf.list.Opts.FilterContext): boolean|nil` 可选的过滤器，或 `nil` 表示全部。
  ---   - `my.buf.list.Opts.Filter`:
  ---     - pattern: `string|string[]`
  ---     - mode: `"filetype"|"glob"|"regex"`
  ---     - filter?: `fun(ctx: my.buf.list.Opts.Filter.FilterContext): boolean|nil`
  --- - listed?: `boolean`(default: `true`) buflisted
  function M.list(opts)
    vim.validate("opts", opts, "table", true)
    opts = opts or {}
    vim.validate("opts.filter", opts.filter, { "table", "function" }, true)
    local items = format_items(get_buf_items(opts))
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, false, {
      relative = "laststatus",
      anchor = "SW",
      row = 0,
      col = 0,
      height = #items,
      width = 10000,
      style = "minimal",
      border = {
        " ",
        { " ", "MsgSeparator" },
        " ",
        "",
        "",
        "",
        "",
        "",
      },
    })
    vim.api.nvim_buf_set_name(buf, "[Buflist]")
    vim.api.nvim_set_option_value("winhl", "Normal:MsgArea", { scope = "local", win = win })
    vim.api.nvim_set_option_value("winfixbuf", true, { scope = "local", win = win })
    vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = win })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)
    vim.api.nvim_set_option_value("modifiable", false, { scope = "local", buf = buf })
    vim.api.nvim_set_option_value("filetype", "buflist", { scope = "local", buf = buf })
    local group = vim.api.nvim_create_augroup("my.buf.list.ui", { clear = true })

    local function close()
      vim.api.nvim_del_augroup_by_id(group)
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_buf_delete(buf, { force = true })
    end

    vim.keymap.set("n", "q", close, { buf = buf, nowait = true })
    vim.keymap.set("n", "<cr>", function() end, { buf = buf })
    vim.keymap.set("n", "%", function() end, { buf = buf })
    vim.api.nvim_create_autocmd("WinLeave", {
      group = group,
      callback = function()
        if vim.api.nvim_get_current_win() == win then
          close()
          return true
        end
      end,
    })
  end
end

return M
