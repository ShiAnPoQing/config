local M = {}

--- @param should_unpack boolean?               #默认 false 不解包
--- @overload fun(should_unpack:nil|false): integer[],integer[]
--- @overload fun(should_unpack:true): integer, integer, integer, integer
function M.get_visual_mark(should_unpack)
  local start_mark = vim.api.nvim_buf_get_mark(0, "<")
  local end_mark = vim.api.nvim_buf_get_mark(0, ">")

  if not should_unpack then
    return start_mark, end_mark
  end

  return start_mark[1], start_mark[2], end_mark[1], end_mark[2]
end

--- @overload fun(start_row:integer, start_col:integer, end_row:integer, end_col:integer): nil
--- @overload fun(start_mark:integer[], end_mark:integer[]): nil
function M.set_visual_mark(...)
  local p1 = select(1, ...)
  local p2 = select(2, ...)
  local p3 = select(3, ...)
  local p4 = select(4, ...)

  if type(p1) == "table" then
    vim.api.nvim_buf_set_mark(0, "<", p1[1], p1[2], {})
    vim.api.nvim_buf_set_mark(0, ">", p2[1], p2[2], {})
  elseif type(p1) == "number" then
    vim.api.nvim_buf_set_mark(0, "<", p1, p2, {})
    vim.api.nvim_buf_set_mark(0, ">", p3, p4, {})
  end
end

return M
