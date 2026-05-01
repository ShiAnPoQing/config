local M = {}

---@param node TSNode|nil
---@return TSNode|nil
local function get_named_node(node)
  if node == nil then
    return
  end
  if node:type() == "function_declaration" then
    return node
  end
  return get_named_node(node:parent())
end

---@param node TSNode
---@return TSNode|nil
local function get_adjacent_comment_node(node)
  local prev_node = node:prev_named_sibling()
  local comment_node
  while prev_node and prev_node:type() == "comment" do
    comment_node = prev_node
    prev_node = prev_node:prev_named_sibling()
  end
  return comment_node
end

---@param item vim.quickfix.entry
function M.get_definition_node_range(item)
  local bufnr = item.bufnr
  local parser = vim.treesitter.get_parser(bufnr)
  local tree = parser:parse()[1]
  local root = tree:root()
  local node = get_named_node(root:descendant_for_range(item.lnum - 1, item.col, item.lnum - 1, item.end_col))
  local start_row, start_col, end_row, end_col
  if node then
    start_row, start_col, end_row, end_col = node:range()
    local comment_node = get_adjacent_comment_node(node)
    if comment_node then
      start_row, start_col = comment_node:range()
    end
  end

  return start_row, start_col, end_row, end_col
end

return M
