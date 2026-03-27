local M = {}

function M.get_cmdline_and_cmdpos()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  return cmd, pos
end

return M
