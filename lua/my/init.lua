--- @class my.g: { [string]: any }
--- @class my.b: vim.var_accessor
--- @class my.w: vim.var_accessor
--- @class my.t: vim.var_accessor

--- @class my
--- @field [-1] my
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
--- @field atom my.atom
--- @field lsp my.lsp
--- @field g my.g
--- @field b my.b
--- @field w my.w
--- @field t my.t
--- @field go my.g
--- @field bo my.b
--- @field wo my.w
--- @field buf my.buf
--- @field win my.win
--- @field ui my.ui
--- @field treesitter my.treesitter
_G.my = _G.my
  or {
    [-1] = setmetatable({}, {
      __index = function(t, k)
        if my._submodules[k] then
          t[k] = require("my." .. k)
          return t[k]
        end
      end,
    }),
  }
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
  lsp = true,
  atom = true,
  motion = true,
  insert = true,
  edit = true,
  buf = true,
  ui = true,
  treesitter = true,
}

local function accesss_my(paths)
  local t = my[-1]
  for _, path in ipairs(paths) do
    local value = t[path]
    if value == nil then
      break
    end
    t = value
  end
  return t
end

--- @param t table
--- @return boolean
local function is_only_index_metatable(t)
  local metatable = getmetatable(t)
  if not metatable then
    return true
  end
  local keys = vim.tbl_keys(metatable)
  if #keys == 1 and keys[1] == "__index" then
    return true
  end
  return false
end

local function create_root(parent_root, path)
  local root = vim.tbl_extend("force", {}, parent_root or {})
  root[#root + 1] = path
  return root
end

local function get_proxy_module(root, mod)
  return setmetatable({ ["[[__root__]]"] = root }, {
    __index = function(t, k)
      if type(mod) == "function" then
        mod = mod()
      end
      local value = mod and mod[k]
      if value then
        if type(value) == "table" and is_only_index_metatable(value) then
          t[k] = get_proxy_module(create_root(root, k), value)
          return t[k]
        end
        return value
      else
        local _mod = accesss_my(root)
        local _value = _mod and _mod[k]
        if type(_value) == "table" and is_only_index_metatable(_value) then
          t[k] = get_proxy_module(create_root(root, k), value)
          return t[k]
        end
        return _value
      end
    end,
  })
end

setmetatable(my, {
  __index = function(t, key)
    if key == "env" then
      t[key] = require("my." .. key)
      return t[key]
    end
    if type(key) == "number" then
      return my.env.get(key)
    end
    t[key] = get_proxy_module({ key }, function()
      return (my.env.get(0) or {})[key]
    end)
    return t[key]
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
      --- @diagnostic disable-next-line: undefined-field
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

do
  function my.trim_current_line()
    local lnum = vim.fn.line(".")
    my.buf.trim_lines(0, lnum - 1, lnum)
  end

  function my.trim_current_line_trail()
    local lnum = vim.fn.line(".")
    my.buf.trim_lines(0, lnum - 1, lnum, { mode = "trail" })
  end

  function my.trim_current_line_lead()
    local lnum = vim.fn.line(".")
    my.buf.trim_lines(0, lnum - 1, lnum, { mode = "lead" })
  end

  vim.keymap.set("n", "<Plug>(my.trim_current_line)", "<Cmd>lua my.trim_current_line()<Cr>")
  vim.keymap.set("n", "<Plug>(my.trim_current_line_lead)", "<Cmd>lua my.trim_current_line_lead()<Cr>")
  vim.keymap.set("n", "<Plug>(my.trim_current_line_trail)", "<Cmd>lua my.trim_current_line_trail()<Cr>")

  vim.api.nvim_create_user_command("TrimLine", function(args)
    if args.range == 0 then
      vim.api.nvim_feedkeys(vim.keycode("<Plug>(my.trim_current_line)"), "nt", false)
      return
    end
    my.buf.trim_lines(0, args.line1 - 1, args.line2)
  end, { range = true })

  vim.api.nvim_create_user_command("TrimLineTrail", function(args)
    if args.range == 0 then
      vim.api.nvim_feedkeys(vim.keycode("<Plug>(my.trim_current_line_trail)"), "nt", false)
      return
    end
    my.buf.trim_lines(0, args.line1 - 1, args.line2, { mode = "trail" })
  end, { range = true })

  vim.api.nvim_create_user_command("TrimLineLead", function(args)
    if args.range == 0 then
      vim.api.nvim_feedkeys(vim.keycode("<Plug>(my.trim_current_line_lead)"), "nt", false)
      return
    end
    my.buf.trim_lines(0, args.line1 - 1, args.line2, { mode = "lead" })
  end, { range = true })
end

do
  --- @param WORD boolean|nil
  local function trim_cword_trail(WORD)
    local pattern = WORD and [[\S\+]] or [[\(\%(\%(\k\)\@!\S\)\+\)\|\(\k\+\)]]
    local cursor = vim.api.nvim_win_get_cursor(0)
    local matches = my.buf_match(0, pattern, cursor, { count = 2 })
    if #matches < 2 then
      return
    end
    if matches[1].col > cursor[2] then
      return
    end
    local cword_match = matches[1]
    local nword_match = matches[2]
    if cword_match.end_col == nword_match.col then
      return
    end
    if cword_match.lnum == nword_match.lnum then
      local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
      local left_part = line:sub(1, cword_match.end_col)
      local right_part = line:sub(nword_match.col + 1)
      vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { left_part .. right_part })
    else
      local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
      local new_line = line:sub(1, cword_match.end_col)
      vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { new_line })
    end
  end

  --- @param WORD boolean|nil
  local function trim_cword_lead(WORD)
    local pattern = WORD and [[\S\+]] or [[\(\%(\%(\k\)\@!\S\)\+\)\|\(\k\+\)]]
    local cursor = vim.api.nvim_win_get_cursor(0)
    local start = { cursor[1], cursor[2] }
    if WORD and my.cursor.at_WORD_start() or my.cursor.at_word_start() then
      start[2] = start[2] + 1
    end
    local matches = my.buf_match(0, pattern, start, { count = 2, backward = true })
    if #matches < 2 then
      return
    end
    if matches[1].end_col < cursor[2] then
      return
    end
    local cword_match = matches[1]
    local nword_match = matches[2]
    if cword_match.col == nword_match.end_col then
      return
    end
    if cword_match.lnum == nword_match.lnum then
      local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
      local new_line = line:sub(1, nword_match.end_col) .. line:sub(cword_match.col + 1)
      vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { new_line })
      cursor[2] = cursor[2] + #new_line - #line
    else
      local line = vim.api.nvim_buf_get_lines(0, cword_match.lnum - 1, cword_match.lnum, true)[1]
      local new_line = line:sub(cword_match.col + 1)
      cursor[2] = cursor[2] + #new_line - #line
      vim.api.nvim_buf_set_lines(0, cword_match.lnum - 1, cword_match.lnum, true, { new_line })
    end
    vim.api.nvim_win_set_cursor(0, cursor)
  end

  function my.trim_cword_trail()
    trim_cword_trail()
  end

  function my.trim_cWORD_trail()
    trim_cword_trail(true)
  end

  function my.trim_cword_lead()
    trim_cword_lead()
  end

  function my.trim_cWORD_lead()
    trim_cword_lead(true)
  end

  function my.trim_cword() end
end

do
  function my.delete_surround() end
end

do
  --- @return boolean
  local function is_subclass(class1, class2)
    local static = getmetatable(class1.static).__index

    while static do
      if static == class2.static then
        return true
      end
      local mt = getmetatable(static)
      static = mt and mt.__index
    end

    return false
  end

  --- @return boolean
  local function is_instance(instance, class)
    local prototype = getmetatable(instance).__index

    while prototype do
      if prototype == class.__prototype__ then
        return true
      end
      local mt = getmetatable(prototype)
      prototype = mt and mt.__index
    end

    return false
  end

  local create_class

  --- @param name string
  local function extend(base, name)
    return create_class(name, base)
  end

  --- @param name string
  function create_class(name, base)
    local class = {
      name = name,
      __prototype__ = setmetatable({ is_instance_of = is_instance }, { __index = base and base.__prototype__ or {} }),
      static = setmetatable({
        is_subclass_of = is_subclass,
        extend = extend,
      }, { __index = base and base.static or {} }),
    }

    local super_mt = base
        and {
          __index = function(self, _k)
            local value = base.__prototype__[_k]
            if type(value) == "function" then
              return function(_, ...)
                return value(self.__instance__, ...)
              end
            end
            return value
          end,
          __call = function(self, ...)
            local init = base.__prototype__.init
            if type(init) == "function" then
              init(self.__instance__, ...)
            end
          end,
        }
      or nil

    setmetatable(class, {
      __index = class.static,
      __newindex = function(_, k, v)
        class.__prototype__[k] = v
      end,
      __call = function(_, ...)
        local instance = {}
        setmetatable(instance, { __index = class.__prototype__ })
        if super_mt then
          instance.super = setmetatable({ __instance__ = instance }, super_mt)
        end
        if instance.init then
          instance:init(...)
        end
        return instance
      end,
    })
    return class
  end
  --- @class my.Class<T>
  --- @field name string
  --- @field is_subclass_of fun(self: T, class2): boolean
  --- @field extend fun(self: T, name: string): T
  --- @overload fun(...): my.Instance|T

  --- @class my.Instance<T>
  --- @field super T
  --- @field is_instance_of fun(self: my.Instance<T>, class): boolean

  ---@generic T
  ---@param name T
  ---@return my.Class<T>
  function my.class(name)
    return create_class(name)
  end
end
