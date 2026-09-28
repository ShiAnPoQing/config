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
          my.util.try(wrap.primary.enter)
          return
        end

        if not secondary and my.multicursor.active() then
          secondary = {}
          my.util.try(wrap.secondary.enter)
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

return M
