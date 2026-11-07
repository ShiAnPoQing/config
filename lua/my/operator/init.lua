--- @class my.operator
local M = vim._defer_require("my.operator", {})

--- @type table<string, {primary: my.operator.WrapOpts?, secondary: my.operator.WrapOpts?}>
local wraps = {}
local group

--- @param operator string
local function disable_wrap(operator)
  wraps[operator] = nil
  if vim.tbl_isempty(wraps) then
    pcall(vim.api.nvim_del_augroup_by_name, group)
  end
end

--- @param operator string
--- @param opts my.operator.WrapOpts?
--- @param opts2 my.operator.WrapOpts?
local function enable_wrap(operator, opts, opts2)
  if not vim.tbl_isempty(wraps) then
    wraps[operator] = {
      primary = vim.tbl_deep_extend("force", {}, opts),
      secondary = vim.tbl_deep_extend("force", {}, opts2),
    }
    return
  end
  wraps[operator] = {
    primary = vim.tbl_deep_extend("force", {}, opts),
    secondary = vim.tbl_deep_extend("force", {}, opts2),
  }

  local primary
  local secondary

  group = vim.api.nvim_create_augroup("my.operator.wrap", { clear = true })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function(ev)
      local match = ev.match
      local op = vim.v.operator
      if match == "n:no" and op and op ~= "" and vim.list_contains(vim.tbl_keys(wraps), op) then
        local wrap = wraps[op]
        if not primary then
          primary = {}
          primary.context = my.util.try(wrap.primary.enter)
          return
        end

        if not secondary and my.multicursor.active() then
          secondary = {}
          secondary.context = my.util.try(wrap.secondary.enter)
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("CmdAtom", {
    group = group,
    callback = function(ev)
      if primary then
        local op = ev.data.operator
        if vim.tbl_contains(vim.tbl_keys(wraps), op) then
          local wrap = wraps[op]
          my.util.try(wrap.primary.done, primary.context)

          if not secondary then
            return
          end

          my.util.try(wrap.secondary.done, secondary.context)
        end
        primary = nil
        secondary = nil
      end
    end,
  })
end

--- @class my.operator.WrapOpts
--- @field enter? fun(): any
--- @field done? fun(ctx: any)

--- @param operator string
--- @param opts my.operator.WrapOpts?
--- @param opts2 my.operator.WrapOpts?
function M.wrap(operator, opts, opts2)
  vim.validate("operator", operator, "string")
  vim.validate("opts", opts, "table", true)
  vim.validate("opts2", opts2, "table", true)
  if opts == nil and opts2 == nil then
    disable_wrap(operator)
  else
    enable_wrap(operator, opts or {}, opts2 or {})
  end
end

local op_ctx

local function get_operator_origins()
  local origins = { vim.api.nvim_win_get_cursor(0) }
  for _, cursor in ipairs(my.multicursor.get(0, 0, -1)) do
    table.insert(origins, { cursor[2] + 1, cursor[3] })
  end
  return origins
end

local function is_empty(start_pos, end_pos)
  if end_pos[1] == start_pos[1] and end_pos[2] < start_pos[2] then
    return true
  end

  local end_line = vim.api.nvim_buf_get_lines(0, end_pos[1] - 1, end_pos[1], false)[1]
  if end_pos[1] < start_pos[1] and end_pos[2] + 1 == (#end_line == 0 and 1 or #end_line) then
    return true
  end
  return false
end

--- @return boolean
function M.is_operatorfunc()
  if type(vim.o.operatorfunc) == "string" and vim.o.operatorfunc:find("my.operator") then
    return true
  end
  return false
end

-- better delete: better cursor position
--- @param type "char"|"line"|"block"|nil
function M.delete(type)
  if not type then
    vim.o.operatorfunc = "v:lua.my.operator.delete"
    op_ctx = { reg = vim.v.register }
    op_ctx.origins = get_operator_origins()
    op_ctx.mode = vim.api.nvim_get_mode().mode
    return "g@"
  end
  local origin = table.remove(op_ctx.origins, 1)
  local delete = '"' .. op_ctx.reg .. "d"
  if type == "char" then
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")

    if is_empty(start_pos, end_pos) then
      return
    end

    local selection = vim.o.selection
    local virtualedit = vim.o.virtualedit
    vim.o.virtualedit = "onemore"
    -- 强制使用 inclusive 选择模式
    vim.o.selection = "inclusive"
    vim.cmd("normal! `[v`]" .. delete)
    vim.o.selection = selection
    vim.o.virtualedit = virtualedit

    if start_pos[1] == origin[1] and end_pos[1] == origin[1] then
      if start_pos[2] < origin[2] and end_pos[2] < origin[2] then
        vim.api.nvim_win_set_cursor(0, { origin[1], origin[2] - math.abs(start_pos[2] - end_pos[2]) - 1 })
        return
      end
      if start_pos[2] > origin[2] and end_pos[2] > origin[2] then
        vim.api.nvim_win_set_cursor(0, origin)
        return
      end
    end

    return
  end
  if type == "line" then
    local view = vim.fn.winsaveview()
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")
    vim.cmd("normal! `[V`]" .. delete)
    if
      (start_pos[1] <= origin[1] and end_pos[1] <= origin[1])
      or (start_pos[1] >= origin[1] and end_pos[1] > origin[1])
    then
      view.col = origin[2]
    end
    if start_pos[1] > origin[1] and end_pos[1] > origin[1] then
      view.lnum = origin[1]
      view.col = origin[2]
    end
    if start_pos[1] < origin[1] and end_pos[1] < origin[1] then
      view.lnum = origin[1] - math.abs(start_pos[1] - end_pos[1]) - 1
      view.col = origin[2]
    end
    vim.fn.winrestview(view)
    return
  end

  if type == "block" then
    vim.cmd("normal! `[" .. vim.keycode("<C-V>") .. "`]" .. delete)
    return
  end
end

--- @param type "char"|"line"|"block"|nil
function M.yank(type)
  if not type then
    vim.o.operatorfunc = "v:lua.my.operator.yank"
    op_ctx = { reg = vim.v.register }
    op_ctx.origins = get_operator_origins()
    return "g@"
  end

  local origin = table.remove(op_ctx.origins, 1)
  local y = '"' .. op_ctx.reg .. "y"
  if type == "char" then
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")
    if is_empty(start_pos, end_pos) then
      return
    end
    vim.cmd("normal! `[v`]" .. y)
  elseif type == "line" then
    vim.cmd("normal! '[V']" .. y)
  elseif type == "block" then
    vim.cmd("normal! `[" .. vim.keycode("<C-V>") .. "`]" .. y)
  end
  vim.api.nvim_win_set_cursor(0, origin)
end

--- @param type "char"|"line"|"block"
local function join(type)
  local origin = table.remove(op_ctx.origins, 1)
  if type == "line" then
    local join_key = op_ctx.opts.only_join and "gJ" or "J"
    local view = vim.fn.winsaveview()
    view.col = origin[2]
    if vim.list_contains({ "v", "V", "" }, op_ctx.mode) then
      vim.cmd("normal! `[V`]" .. join_key)
    end
    local count = vim.v.count1 + 1
    vim.cmd("normal! " .. count .. join_key)
    vim.fn.winrestview(view)
  end
end

--- @class my.operator.join.Opts
--- @field only_join? boolean

--- @param tp "char"|"line"|"block"
--- @return string
--- @overload fun(opts?: my.operator.join.Opts)
function M.join(tp)
  if type(tp) == "string" then
    join(tp)
    return
  end
  local opts = tp or {} --[[@as my.operator.join.Opts]]
  if opts.only_join then
    vim.o.operatorfunc = "v:lua.my.operator.join1"
    M.join1 = function(t)
      return M.join(t)
    end
  else
    vim.o.operatorfunc = "v:lua.my.operator.join"
  end
  op_ctx = {}
  op_ctx.origins = get_operator_origins()
  op_ctx.mode = vim.api.nvim_get_mode().mode
  op_ctx.opts = opts
  return "g@"
end

local function uppercase(type)
  local origin = table.remove(op_ctx.origins)
  if type == "char" then
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")
    if is_empty(start_pos, end_pos) then
      return
    end
    vim.cmd("normal! `[v`]gU")
  elseif type == "line" then
    vim.cmd("normal! '[V']gU")
  elseif type == "block" then
    vim.cmd("normal! `[" .. vim.keycode("<C-V>") .. "`]gU")
  end
  vim.api.nvim_win_set_cursor(0, origin)
end

local function lowercase(type)
  local origin = table.remove(op_ctx.origins)
  if type == "char" then
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")
    if is_empty(start_pos, end_pos) then
      return
    end
    vim.cmd("normal! `[v`]gu")
  elseif type == "line" then
    vim.cmd("normal! '[V']gu")
  elseif type == "block" then
    vim.cmd("normal! `[" .. vim.keycode("<C-V>") .. "`]gu")
  end
  vim.api.nvim_win_set_cursor(0, origin)
end

function M.lowercase(tp)
  if type(tp) == "string" then
    lowercase(tp)
  end
  vim.o.operatorfunc = "v:lua.my.operator.lowercase"
  op_ctx = {}
  op_ctx.origins = get_operator_origins()
  return "g@"
end

function M.uppercase(tp)
  if type(tp) == "string" then
    uppercase(tp)
  end
  vim.o.operatorfunc = "v:lua.my.operator.uppercase"
  op_ctx = {}
  op_ctx.origins = get_operator_origins()
  return "g@"
end

function M.get_operatorfunc_command()
  if not M.is_operatorfunc() then
    return
  end
  local func = vim.o.operatorfunc
  if func == "v:lua.my.operator.join1" then
    return "<Cmd>lua my.operator.join({ only = true })<Cr>"
  end
  return "<Cmd>lua " .. func:gsub("v:lua.", "") .. "()<Cr>"
end

function M.is_delete_operatorfunc()
  return vim.o.operatorfunc == "v:lua.my.operator.delete"
end

function M.is_delete_operator()
  return vim.v.operator == "g@" and M.is_delete_operatorfunc()
end

function M.is_yank_operatorfunc()
  return vim.o.operatorfunc == "v:lua.my.operator.yank"
end

function M.is_yank_operator()
  return vim.v.operator == "g@" and M.is_yank_operatorfunc()
end

function M.is_join_operatorfunc()
  return vim.o.operatorfunc == "v:lua.my.operator.join" or vim.o.operatorfunc == "v:lua.my.operator.join1"
end

function M.is_join_operator()
  return vim.v.operator == "g@" and M.is_join_operatorfunc()
end

function M.is_uppercase_operatorfunc()
  return vim.o.operatorfunc == "v:lua.my.operator.uppercase"
end

function M.is_uppercase_operator()
  return vim.v.operator == "g@" and M.is_uppercase_operatorfunc()
end

function M.is_lowercase_operatorfunc()
  return vim.o.operatorfunc == "v:lua.my.operator.lowercase"
end

function M.is_lowercase_operator()
  return vim.v.operator == "g@" and M.is_lowercase_operatorfunc()
end

return M
