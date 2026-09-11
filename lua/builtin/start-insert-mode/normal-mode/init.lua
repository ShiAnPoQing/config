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
      key = "<Ignore>"
      local marks = vim.api.nvim_buf_get_extmarks(0, vim.api.nvim_create_namespace("nvim.multicursor"), 0, -1)
      if #marks > 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>1q=g_", true, false, true), "n", false)
        vim.api.nvim_feedkeys("2q=", "nt", false)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>g_", true, false, true), "n", false)
      end
      vim.api.nvim_feedkeys(count .. "a", "nt", false)
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
