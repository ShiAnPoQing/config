local constants = setmetatable({}, { __newindex = function() end })

--- @class my.command
--- @field constants table<string,string>
local M = setmetatable({ constants = constants }, {
  __newindex = function(t, key, value)
    if key == "constants" then
      return
    end
    rawset(t, key, value)
  end,
})

--- @param constant string
--- @param name string
--- @param cmd string|fun(args: vim.api.keyset.create_user_command.command_args)
--- @param opts vim.api.keyset.user_command?
function M.define(constant, name, cmd, opts)
  opts = opts or {}
  vim.validate("constant", constant, "string")
  vim.validate("name", name, "string")
  local ok, err = pcall(vim.api.nvim_create_user_command, name, cmd, opts)
  if not ok then
    vim.schedule(function()
      vim.api.nvim_echo({ { err, "ErrorMsg" } }, true, {})
    end)
    return
  end
  rawset(constants, constant, name)
end

return M
