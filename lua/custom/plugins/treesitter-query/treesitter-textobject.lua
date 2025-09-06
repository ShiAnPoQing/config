local M = {}

local function visual(start_row, start_col, end_row, end_col)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "v" or mode == "" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
  end

  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })
end

--- @class textobject_options
--- @field language string
--- @field scm string
--- @field query string

--- @param opts textobject_options
function M.textobject(opts)
  local query = vim.treesitter.query.get(opts.language, opts.scm)
  if query == nil then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, opts.language):parse()[1]

  local pos = vim.api.nvim_win_get_cursor(0)
  local cur_row = pos[1] - 1

  for id, node, metadata, match in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local name = query.captures[id]

    if name == opts.query then
      local start_row, start_col, end_row, end_col = node:range()

      if cur_row >= start_row and cur_row <= end_row then
        visual(start_row, start_col, end_row, end_col)
        return
      end

      if cur_row <= start_row then
        visual(start_row, start_col, end_row, end_col)
        return
      end
    end
  end
end

return M
