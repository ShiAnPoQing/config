local M = {}

local get_current_line = function()
  return vim.api.nvim_get_current_line()
end

function M.first_non_blank_character()
  local key
  local line = get_current_line()
  if #line == 0 then
    key = "I<C-f>"
  else
    key = "I"
  end
  return key
end

function M.last_non_blank_character()
  local key
  local line = get_current_line()
  local count = vim.v.count1
  if #line == 0 then
    key = "<Esc>g_" .. count .. "a<C-f>"
  else
    key = "<Esc>g_" .. count .. "a"
  end
  return key
end

function M.last_character()
  local key
  local line = get_current_line()
  if #line == 0 then
    key = "A<C-f>"
  else
    key = "A"
  end
  return key
end

return M
