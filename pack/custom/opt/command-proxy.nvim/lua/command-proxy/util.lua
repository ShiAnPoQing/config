local M = {}

--- @param index integer
function M.get_command_proxy_completion(index)
  local completions = {
    vim.tbl_keys(require("command-proxy").command),
    require("command-proxy").get_proxy_cmds(),
  }
  return completions[index] or completions[2]
end

return M
