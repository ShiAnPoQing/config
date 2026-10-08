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

-- local origin
--
-- function M.get_origin()
--   return origin
-- end
--
-- function M.init()
--   vim.api.nvim_create_autocmd("ModeChanged", {
--     pattern = "*:no*",
--     callback = function()
--       origin = vim.api.nvim_win_get_cursor(0)
--     end,
--   })
-- end

local operator_context

function M._pending_delete_(context)
  vim.o.operatorfunc = "v:lua.my.operator._delete_"
  operator_context = context
  operator_context.origin = vim.api.nvim_win_get_cursor(0)
end

--- @param type "char"|"line"|"block"
function M._delete_(type)
  -- vim.api.nvim_create_autocmd("CmdAtom", {
  --   callback = function(ev)
  --     ev.data.lhs = vim.fn.keytrans(ev.data.lhs)
  --     vim.print(ev.data)
  --     return true
  --   end,
  -- })
  local origin = operator_context.origin
  local d = '"' .. operator_context.reg .. "d"
  if type == "char" then
    local start_pos = vim.fn.getpos("'[")
    vim.cmd("normal! `[v`]" .. d)
    if start_pos[2] == origin[1] and start_pos[3] > origin[2] then
      vim.api.nvim_win_set_cursor(0, origin)
    end
    return
  end

  if type == "line" then
    vim.cmd("normal! '[V']" .. d)
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
  operator_context = context
  operator_context.origin = vim.api.nvim_win_get_cursor(0)
end

--- @param type "char"|"line"|"block"
function M._yank_(type)
  local origin = operator_context.origin
  local y = '"' .. operator_context.reg .. "y"
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
