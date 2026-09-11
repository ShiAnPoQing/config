local M = {}

function M.nimbus()
  local path = vim.fn.getcwd()
  for name, type in vim.fs.dir(path) do
    vim.print(name, type)
  end
end

--- @class Nimbus.Config

--- @param config? Nimbus.Config
function M.setup(config)
  config = config or {}
end

M.nimbus()

return M
