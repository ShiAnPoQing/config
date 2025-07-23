-- -- treesitter_textobject.lua
-- -- 纯官方API实现函数textobject（以Lua为例）
--
-- -- 获取光标下最近的函数节点（官方API）
-- local function get_function_node(inner)
--   -- 获取光标位置
--   local pos = vim.api.nvim_win_get_cursor(0)
--   local row = pos[1] - 1
--   local col = pos[2]
--
--   -- 获取光标下的最小命名节点
--   local node = vim.treesitter.get_node({ pos = { row, col } })
--   while node do
--     if node:type() == "function_declaration" then
--       if inner then
--         -- 查找函数体
--         for i = 0, node:named_child_count() - 1 do
--           local child = node:named_child(i)
--           if child:type() == "block" then
--             return child
--           end
--         end
--       end
--       return node
--     end
--     node = node:parent()
--   end
-- end
--
-- -- 选中函数textobject
-- local function select_function(inner)
--   local node = get_function_node(inner)
--   if not node then
--     vim.notify("未找到函数节点", vim.log.levels.WARN)
--     return
--   end
--   local start_row, start_col, end_row, end_col = node:range()
--   -- 进入可视模式并选中范围
--   vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
--   vim.cmd('normal! v')
--   vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
-- end
--
-- return {
--   select_function = select_function
-- }
--


local M = {}


--- @class opts
--- @field language string
--- @field scm string

--- @param opts opts
function M.textobject(opts)
  local query = vim.treesitter.query.get(opts.language, opts.scm)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, opts.language)
  local tree = parser:parse()[1]
  local root = tree:root()
  local pos = vim.api.nvim_win_get_cursor(0)
  local cur_row = pos[1] - 1
  local cur_col = pos[2]

  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    local name = query.captures[id]
    if name == "funcname" then
      local start_row, start_col, end_row, end_col = node:range()

      -- 判断光标是否在该节点内
      if cur_row >= start_row and cur_row <= end_row then
        vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
        vim.cmd('normal! v')
        vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })
        return
      end
    end
  end
  print("未找到函数名节点")
end

function M.test()
  local query = vim.treesitter.query.get("typescript", "mytextobjects")
  print(vim.inspect(query))
end

return M
