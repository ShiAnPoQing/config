local S = require("builtin.cmdline.shared")
local M = {}

function M.first_non_blank_character()
  local cmd, pos = S.get_cmdline_and_cmdpos()
  local _, new_pos = cmd:find("^%s*[^%s]")
  if not new_pos then
    return
  end
  vim.fn.setcmdline(cmd, new_pos == pos and 1 or new_pos)
end

function M.last_non_blank_character()
  local cmd, pos = S.get_cmdline_and_cmdpos()
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

function M.middle()
  local cmd = vim.fn.getcmdline()
  local new_pos = math.floor(#cmd / 2)
  vim.fn.setcmdline(cmd, new_pos + 1)
end

function M.delete_to_first_non_blank_character()
  local cmd, pos = S.get_cmdline_and_cmdpos()
  local _, new_pos = cmd:find("^%s*[^%s]")
  if not new_pos then
    return
  end
  local part1 = cmd:sub(1, new_pos - 1)
  local new_cmdline = part1 .. cmd:sub(pos)
  vim.fn.setcmdline(new_cmdline, #part1 + 1)
end

function M.delete_to_last_non_blank_character()
  local cmd, pos = S.get_cmdline_and_cmdpos()
  local new_pos = cmd:find("[^%s]%s*$")
  if not new_pos then
    return
  end
  local new_cmdline = cmd:sub(1, pos - 1) .. cmd:sub(new_pos + 1)
  vim.fn.setcmdline(new_cmdline, pos)
end

function M.delete_to_first_character()
  local cmd, pos = S.get_cmdline_and_cmdpos()
  vim.fn.setcmdline(cmd:sub(pos), 1)
end

function M.delete_to_last_character()
  local cmd, pos = S.get_cmdline_and_cmdpos()
  vim.fn.setcmdline(cmd:sub(1, pos - 1), pos)
end

return M
