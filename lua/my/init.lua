--- @class my.g: { [string]: any }
--- @class my.b: vim.var_accessor
--- @class my.w: vim.var_accessor
--- @class my.t: vim.var_accessor

--- @class my
--- @field env my.env
--- @field command my.command
--- @field keymap my.keymap
--- @field window my.window
--- @field scroll my.scroll
--- @field multicursor my.multicursor
--- @field insert my.insert
--- @field operator my.operator
--- @field motion my.motion
--- @field edit my.edit
--- @field cursor my.cursor
--- @field util my.util
--- @field option my.option
--- @field macro my.macro
--- @field repeat my.repeat
--- @field atom my.atom
--- @field _atom my._atom
--- @field lsp my.lsp
--- @field g my.g
--- @field b my.b
--- @field w my.w
--- @field t my.t
_G.my = _G.my or {}
my._submodules = {
  command = true,
  keymap = true,
  window = true,
  multicursor = true,
  cursor = true,
  operator = true,
  option = true,
  util = true,
  env = true,
  scroll = true,
  macro = true,
  ["repeat"] = true,
  atom = true,
  lsp = true,
  _atom = true,
  motion = true,
  insert = true,
  edit = true,
}

setmetatable(my, {
  __index = function(t, key)
    if key == "_" then
      return setmetatable({}, {
        __index = function(_, k)
          if my._submodules[k] then
            t[k] = require("my." .. k)
            return t[k]
          end
        end,
      })
    end
    if key == "env" then
      t[key] = require("my." .. key)
      return t[key]
    end
    if type(key) == "number" then
      return my.env.get(key)
    end
    local env = my.env.get(0)
    if env and env[key] then
      return env[key]
    end
    if my._submodules[key] then
      t[key] = require("my." .. key)
      return t[key]
    end
  end,
})

do
  --- @param scope string
  --- @param handle? false|integer
  --- @param opts { setvar: fun(scope: string, handle:any, k: any, v: any): any; getvar: fun(scope: string, handle:any, k: any): any }
  --- @return vim.var_accessor
  local function make_dict_accessor(scope, handle, opts)
    vim.validate("scope", scope, "string")
    local mt = {}
    --- @param k string
    --- @param v any
    function mt.__newindex(_, k, v)
      return opts.setvar(scope, handle, k, v)
    end

    --- @param k string|integer
    function mt.__index(_, k)
      if handle == nil and type(k) == "number" then
        return make_dict_accessor(scope, k, opts)
      end
      return opts.getvar(scope, handle, k)
    end
    return setmetatable({}, mt)
  end

  local opts = {
    setvar = function(scope, handle, k, v)
      if handle then
        local vars = vim[scope][handle].my or {}
        vars[k] = v
        vim[scope][handle].my = vars
      else
        local vars = vim[scope].my or {}
        vars[k] = v
        vim[scope].my = vars
      end
      return true
    end,
    getvar = function(scope, handle, k)
      if handle then
        if vim[scope][handle].my == nil then
          return nil
        end
        return vim[scope][handle].my[k]
      else
        if vim[scope].my == nil then
          return nil
        end
        return vim[scope].my[k]
      end
    end,
  }

  my.g = make_dict_accessor("g", false, opts)
  my.b = make_dict_accessor("b", nil, opts)
  my.w = make_dict_accessor("w", nil, opts)
  my.t = make_dict_accessor("t", nil, opts)

  local _opts = {
    setvar = function(scope, handle, k, v)
      return my.option.set(scope, handle, k, v)
    end,
    getvar = function(scope, handle, k)
      return my.option.get(scope, handle, k)
    end,
  }
  my.go = make_dict_accessor("g", false, _opts)
  my.bo = make_dict_accessor("b", nil, _opts)
  my.wo = make_dict_accessor("w", nil, _opts)
end

do
  --- @param buf integer
  --- @param start [integer, integer]
  --- @return boolean
  local function check_start(buf, start)
    local lnum = start[1]
    local col = start[2]
    if type(lnum) ~= "number" or type(col) ~= "number" then
      vim.notify(
        string.format('my.buf_match: "start" expected [integer, integer], but got [%s, %s]', type(lnum), type(col)),
        vim.log.levels.ERROR
      )
      return false
    end
    if lnum <= 0 or lnum > vim.api.nvim_buf_line_count(buf) then
      vim.notify("my.buf_match: start[1] out of buf", vim.log.levels.ERROR)
      return false
    end
    if col < 0 or col > #vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, true)[1] then
      vim.notify("my.buf_match: start[2] out of buf", vim.log.levels.ERROR)
      return false
    end
    return true
  end

  --- @class my.buf_match.Opts
  --- @field count? integer 0 is match to buf start or buf end
  --- @field backward? boolean default nil
  --- @field strict? boolean

  --- @class my.buf_match.match
  --- @field lnum integer
  --- @field col integer
  --- @field end_lnum integer
  --- @field end_col integer
  --- @field text string

  --- @param buf integer
  --- @param pattern string
  --- @param start [integer, integer]
  --- @param opts my.buf_match.Opts?
  --- @return my.buf_match.match[]
  function my.buf_match(buf, pattern, start, opts)
    vim.validate("buf", buf, "number")
    vim.validate("pattern", pattern, "string")
    vim.validate("start", start, "table")
    vim.validate("opts", opts, "table", true)
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
    opts = opts or {}
    if not check_start(buf, start) then
      return {}
    end
    local count = type(opts.count) == "number" and opts.count or 1
    local strict = opts.strict
    local backward = opts.backward
    local all
    if count == 0 then
      all = true
    end
    local start_line = start[1]
    local start_col = start[2]
    local buf_line_count = vim.api.nvim_buf_line_count(buf)

    local matches = {}

    local should_match = function()
      return all or #matches < count
    end

    local function match_backward(line)
      if line < 1 then
        return
      end
      --- @type any[]
      local list = vim.fn.matchbufline(buf, pattern, line, line)
      ---@diagnostic disable-next-line: undefined-field
      list = vim.iter(list):rev():totable()
      for _, item in ipairs(list) do
        local col = item.byteidx
        if
          (line == start_line and ((strict and col + #item.text <= start_col) or (not strict and col < start_col)))
          or line ~= start_line
        then
          if not should_match() then
            break
          end
          table.insert(matches, {
            col = item.byteidx,
            lnum = line,
            end_col = item.byteidx + #item.text,
            end_lnum = line,
            text = item.text,
          })
        end
      end
      if should_match then
        match_backward(line - 1)
      end
    end

    local function match_forward(line)
      if line > buf_line_count then
        return
      end
      --- @type any[]
      local list = vim.fn.matchbufline(buf, pattern, line, line)
      for _, item in ipairs(list) do
        local col = item.byteidx
        if
          (line == start_line and ((strict and col >= start_col) or (not strict and col + #item.text > start_col)))
          or line ~= start_line
        then
          if not should_match() then
            break
          end
          table.insert(matches, {
            col = item.byteidx,
            lnum = line,
            end_col = item.byteidx + #item.text,
            end_lnum = line,
            text = item.text,
          })
        end
      end
      if should_match then
        match_forward(line + 1)
      end
    end
    if backward then
      match_backward(start_line)
    else
      match_forward(start_line)
    end
    return matches
  end
end
