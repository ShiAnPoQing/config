--- @class my.command.ProxyContext

--- @class my.command.proxy.Opts
--- @field buf? integer
--- @field win? integer

--- @class my.command.proxy
--- @overload fun(cmd: string, callback: fun(ctx: my.command.ProxyContext): boolean|nil)
local M = {}

local proxys = {}

--- @param cmd string
--- @param callback fun(ctx: my.command.ProxyContext): boolean|nil
--- @param opts my.command.proxy.Opts?
local function proxy(cmd, callback, opts)
  vim.validate("cmd", cmd, "string")
  vim.validate("callback", callback, "function")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
end

--- @param cmd string|string[]
--- @param enable boolean|nil
function M.enable(cmd, enable)
  vim.validate("cmd", cmd, { "string", "table" })
  vim.validate("enable", enable, "boolean", true)
  local cmds = type(cmd) == "string" and { cmd } or cmd --[[@as table<string>]]
end

---@diagnostic disable-next-line: param-type-mismatch
setmetatable(M, {
  __call = function(_, ...)
    proxy(...)
  end,
})

return M
