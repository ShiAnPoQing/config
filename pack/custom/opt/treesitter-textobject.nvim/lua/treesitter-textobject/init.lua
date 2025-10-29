local M = {}

--- @class TreesitterTextobject.Options

--- @param opts? TreesitterTextobject.Options
function M.setup(opts) end

--- @class TreesitterTextobject.textobject
--- @field language string
--- @field query string
--- @field scm string

local function visual(start_row, start_col, end_row, end_col)
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { end_row, end_col })
end

local function is_visual_mode(mode)
  return mode == "v" or mode == "V" or mode == ""
end

local function cursor_at_middle(v_start_row, v_start_col, v_end_row, v_end_col)
  return v_start_row == v_end_row and v_start_col == v_end_col
end

local function cursor_at_left(v_start_row, v_start_col, c_row, c_col)
  return c_row == v_start_row and c_col == v_start_col
end

local function find_target_node(i, nodes, c_row, c_col)
  if i == 0 then
    return
  end
  local node = nodes[i]
  local start_row, start_col = node:range()
  if (start_row + 1 == c_row and start_col < c_col) or start_row + 1 < c_row then
    return node
  end

  return find_target_node(i - 1)
end

--- @param config? TreesitterTextobject.textobject
function M.textobject(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, config.language):parse()[1]
  local query = vim.treesitter.query.get(config.language, config.scm)
  if query == nil then
    return
  end

  local mode = vim.api.nvim_get_mode().mode

  if not is_visual_mode(mode) then
    vim.api.nvim_feedkeys("v", "nx", false)
    M.textobject(config)
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
  local c_row, c_col = unpack(vim.api.nvim_win_get_cursor(0))
  local v_start_row, v_start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local v_end_row, v_end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  local nodes = {}
  for id, node, _, _ in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local name = query.captures[id]
    if name == config.query then
      table.insert(nodes, node)
      local start_row, _, end_row, end_col = node:range()
      if start_row + 1 <= c_row then
        if (end_row + 1 == c_row and end_col - 1 > c_col) or end_row + 1 > c_row then
          break
        end
      end

      if start_row + 1 > c_row then
        break
      end
    end
  end

  if #nodes == 0 then
    vim.api.nvim_feedkeys("gv", "nx", false)
    return
  end

  local target_node
  local last_node = nodes[#nodes]
  local start_row, start_col, end_row, end_col = last_node:range()

  if cursor_at_middle(v_start_row, v_start_col, v_end_row, v_end_col) then
    visual(start_row + 1, start_col, end_row + 1, end_col)
    return
  end

  if cursor_at_left(v_start_row, v_start_col, c_row, c_col) then
    target_node = find_target_node(#nodes, nodes, c_row, c_col)
    if not target_node then
      vim.api.nvim_feedkeys("gv", "nx", false)
      return
    end
    ---@diagnostic disable-next-line: redefined-local
    local start_row, start_col = target_node:range()
    visual(v_end_row, v_end_col, start_row + 1, start_col)
    return
  end

  if end_row + 1 < c_row then
    vim.api.nvim_feedkeys("gv", "nx", false)
    return
  end
  visual(v_start_row, v_start_col, end_row + 1, end_col)
end

return M
