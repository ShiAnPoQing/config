local M = {}

function M.create_cmd() end

--- @param cmd string
function M.execute(cmd)
  return vim.api.nvim_exec2(cmd, { output = true }).output
end

return M
