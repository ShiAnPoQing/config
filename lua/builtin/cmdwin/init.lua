local M = {}

local cmdwintypes = { ":", "/", "?" }

--- @param dir 1|-1
function M.switch_cmdwin(dir)
  local type = vim.fn.getcmdwintype()
  if not vim.tbl_contains(cmdwintypes, type) then
    return
  end
  vim.cmd("close")
  local index
  for i, v in ipairs(cmdwintypes) do
    if v == type then
      index = i
      break
    end
  end
  if dir > 0 then
    index = index == #cmdwintypes and 1 or index + 1
  elseif dir < 0 then
    index = index == 1 and #cmdwintypes or index - 1
  end
  vim.api.nvim_feedkeys("q" .. cmdwintypes[index], "in", false)
end

function M.is_open()
  return vim.tbl_contains(cmdwintypes, vim.fn.getcmdwintype())
end

return M
