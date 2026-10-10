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

function M._pending_delete_(context)
  vim.o.operatorfunc = "v:lua.my.operator._delete_"
  op_ctx = context
  op_ctx.origins = get_operator_origins()
  op_ctx.mode = vim.api.nvim_get_mode().mode
end

--- @param ... [integer, integer]
--- @return boolean
local function is_same_pos(...)
  local first_pos
  for _, pos in ipairs({ ... }) do
    if not first_pos then
      first_pos = pos
    else
      if pos[1] ~= first_pos[1] or pos[2] ~= first_pos[2] then
        return false
      end
    end
  end
  return true
end

--- @param start_pos [integer, integer]
--- @param end_pos [integer, integer]
--- @param origin [integer, integer]
--- @return boolean
local function is_delete_empty(start_pos, end_pos, origin)
  if start_pos[1] == end_pos[1] and is_same_pos(origin, start_pos) and math.abs(end_pos[2] - start_pos[2]) == 1 then
    return true
  end
  if start_pos[1] ~= end_pos[1] and start_pos[2] == 0 and start_pos[1] == end_pos[1] + 1 then
    local line = vim.api.nvim_buf_get_lines(0, end_pos[1] - 1, end_pos[1], false)[1]
    if #line == end_pos[2] + 1 then
      return true
    end
  end
  return false
end

--- @param type "char"|"line"|"block"
function M._delete_(type)
  local origin = table.remove(op_ctx.origins, 1)
  local d = '"' .. op_ctx.reg .. "d"
  if type == "char" then
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")
    start_pos = math.min(start_pos[1], end_pos[1]) and start_pos or end_pos
    end_pos = math.max(start_pos[1], end_pos[1]) and end_pos or start_pos
    if is_delete_empty(start_pos, end_pos, origin) then
      return
    end
    -- 强制使用 inclusive 选择模式
    -- 修复 exclusive 模式下的 {motion} range
    local selection = vim.o.selection
    local virtualedit = vim.o.virtualedit
    vim.o.virtualedit = "onemore"
    vim.o.selection = "inclusive"
    vim.cmd("normal! `[v`]" .. d)
    vim.o.selection = selection
    vim.o.virtualedit = virtualedit

    if start_pos[1] == origin[1] and start_pos[2] > origin[2] then
      vim.api.nvim_win_set_cursor(0, origin)
    end
    return
  end

  if type == "line" then
    vim.cmd("normal! '[V']" .. d)
    if op_ctx.mode ~= "V" then
      vim.api.nvim_win_set_cursor(0, origin)
    end
    return
  end

  if type == "block" then
    vim.cmd("normal! `[" .. vim.keycode("<C-V>") .. "`]" .. d)
    return
  end
end

function M.is_delete_operatorfunc()
  return vim.o.operatorfunc == "v:lua.my.operator._delete_"
end

function M.is_delete_operator()
  return vim.v.operator == "g@" and M.is_delete_operatorfunc()
end

function M.delete()
  local pending_cmd = string.format(
    "<Cmd>lua my.operator._pending_delete_(%s)<Cr>",
    vim.fn.join(vim.fn.split(vim.inspect({ reg = vim.v.register }), "\n"), "")
  )
  vim.api.nvim_feedkeys(vim.keycode(pending_cmd), "nt", false)
  vim.api.nvim_feedkeys(vim.v.count1 .. "g@", "n", false)
end

function M._pending_yank_(context)
  vim.o.operatorfunc = "v:lua.my.operator._yank_"
  op_ctx = context
  op_ctx.origins = get_operator_origins()
end

--- @param type "char"|"line"|"block"
function M._yank_(type)
  local origin = table.remove(op_ctx.origins, 1)
  local y = '"' .. op_ctx.reg .. "y"
  if type == "char" then
    vim.cmd("normal! `[v`]" .. y)
  elseif type == "line" then
    vim.cmd("normal! '[V']" .. y)
  elseif type == "block" then
    vim.cmd("normal! `[" .. vim.keycode("<C-V>") .. "`]" .. y)
  end
  vim.api.nvim_win_set_cursor(0, origin)
end

function M.is_yank_operatorfunc()
  return vim.o.operatorfunc == "v:lua.my.operator._yank_"
end

function M.is_yank_operator()
  return vim.v.operator == "g@" and M.is_yank_operatorfunc()
end

function M.yank()
  local pending_cmd = string.format(
    "<Cmd>lua my.operator._pending_yank_(%s)<Cr>",
    vim.fn.join(vim.fn.split(vim.inspect({ reg = vim.v.register }), "\n"), "")
  )
  vim.api.nvim_feedkeys(vim.keycode(pending_cmd), "nt", false)
  vim.api.nvim_feedkeys("g@", "n", false)
end

return M
