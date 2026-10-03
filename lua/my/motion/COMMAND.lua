--- @class my.motion.COMMAND
local M = {}

local function get_cmdline_and_cmdpos()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  return cmd, pos
end

function M.first_non_blank()
  local cmd, pos = get_cmdline_and_cmdpos()
  local _, new_pos = cmd:find("^%s*[^%s]")
  if not new_pos then
    return
  end
  vim.fn.setcmdline(cmd, new_pos == pos and 1 or new_pos)
end

function M.last_non_blank()
  local cmd, pos = get_cmdline_and_cmdpos()
  local new_pos = cmd:find("[^%s]%s*$")
  if not new_pos then
    return
  end
  if new_pos + 1 == pos then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<End>", true, false, true), "n", true)
  else
    vim.fn.setcmdline(cmd, new_pos + 1)
  end
end


return M
