local M = {}

local get_current_line = function()
  return vim.api.nvim_get_current_line()
end

local function is_blank_line()
  local line = get_current_line()
  return line:find("^%s*$") and true or nil
end

function M.first_non_blank_character()
  local key
  if is_blank_line() then
    key = "I<C-f>"
  else
    key = "I"
  end
  return key
end

function M.last_non_blank_character()
  local key
  local count = vim.v.count1
  local line = get_current_line()

  if #line == 0 then
    key = "a<C-f>"
  else
    if line:find("^%s*$") then
      key = "I<C-f>"
    else
      key = "<Esc>g_" .. count .. "a"
    end
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
