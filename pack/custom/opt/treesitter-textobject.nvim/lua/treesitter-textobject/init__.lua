local M = {}

--- @class TreesitterTextobject.Options

--- @param opts? TreesitterTextobject.Options
function M.setup(opts) end

--- @class TreesitterTextobject.textobject
--- @field language string
--- @field query string
--- @field scm string

local function visual(start_row, start_col, end_row, end_col)
  local mode = vim.api.nvim_get_mode().mode

  local function select()
    vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    vim.cmd("normal! v")
    if end_col > 0 then
      end_col = end_col - 1
    end
    vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
  end

  if mode == "v" or mode == "" or mode == "V" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
    local v_start_row, v_start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local v_end_row, v_end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    if
      v_start_row == start_row + 1
      and v_start_col == start_col
      and v_end_row == end_row + 1
      and v_end_col == end_col - 1
    then
      return false
    else
      select()
      return true
    end
  else
    select()
    return true
  end
end

--- @param config? TreesitterTextobject.textobject
function M.textobject(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, config.language):parse()[1]

  local query = vim.treesitter.query.get(config.language, config.scm)
  if query == nil then
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local cur_row = pos[1] - 1

  local match_node = function(start_row, start_col, end_row, end_col)
    if (cur_row >= start_row and cur_row <= end_row) or cur_row <= start_row then
      return visual(start_row, start_col, end_row, end_col)
    end
  end

  for id, node, _, _ in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local name = query.captures[id]
    if name == config.query then
      local start_row, start_col, end_row, end_col = node:range()
      if match_node(start_row, start_col, end_row, end_col) then
        return
      end
    end
  end
end

return M
