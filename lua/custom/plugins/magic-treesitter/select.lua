local M = {}

function M.import()
  local query = vim.treesitter.query.get("javascript", "mytextobject")
  if query == nil then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, "javascript"):parse()[1]

  local pos = vim.api.nvim_win_get_cursor(0)
  local cur_row = pos[1] - 1

  for id, node, metadata, match in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local name = query.captures[id]

    if name == "import" then
      local start_row, start_col, end_row, end_col = node:range()

      -- 判断光标是否在该节点内
      if cur_row >= start_row and cur_row <= end_row then
        -- visual(start_row, start_col, end_row, end_col)
        return
      end

      if cur_row <= start_row then
        -- visual(start_row, start_col, end_row, end_col)
        return
      end
    end
  end
end

function M.import_current() end

return M
