local M = {}

--- @class Codebox.Config

--- @param config Codebox.Config
function M.setup(config)
  config = config or {}
end

--- @param lang "lua" | "vim"
--- @param count? integer
function M.toggle(lang, count)
  require("codebox.ui").open()
end

M.toggle("lua", 1)

return M
