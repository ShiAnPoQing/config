local M = {}

--- @param str string
--- @param ... integer
function M.char_split(str, ...)
  local args = { ... }
  local char_len = vim.fn.strlen(str)
  local results = {}

  for _, arg in ipairs(args) do
    if arg < char_len then
      local str = vim.fn.strcharpart(str, 0, arg)
    end
  end
end

return M
