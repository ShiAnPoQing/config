local M = {}
local NODE_BEFORE_POINT = -1
local NODE_CONTAIN_POINT = 0
local NODE_AFTER_POINT = 1

local function get_visual_key()
  local mode = vim.api.nvim_get_mode().mode
  local key = "`[o`]"
  if not (mode == "v" or mode == "V" or mode == "") then
    key = "v" .. key
  end
  return key
end

local function update_visual(start_row, start_col, end_row, end_col)
  local key = get_visual_key()
  vim.api.nvim_buf_set_mark(0, "[", start_row, start_col, {})
  vim.api.nvim_buf_set_mark(0, "]", end_row, end_col, {})
  vim.api.nvim_feedkeys(key, "nx", false)
end

local function get_node_relative_point(node, point)
  local start_row, start_col, end_row, end_col = node:range()
  if
    (start_row < point.row or (start_row == point.row and start_col < point.col))
    and (end_row > point.row or (end_row == point.row and end_col > point.col))
  then
    return NODE_CONTAIN_POINT
  elseif start_row > point.row or (start_row == point.row and start_col > point.col) then
    return NODE_AFTER_POINT
  elseif end_row < point.row or (end_row == point.row and end_col < point.col) then
    return NODE_BEFORE_POINT
  end
end

local function get_visual_points()
  local _, c_row, c_col = unpack(vim.fn.getpos("."))
  local _, v_row, v_col = unpack(vim.fn.getpos("v"))
  local start_point = {
    row = c_row - 1,
    col = c_col,
    cursor = true,
  }
  local end_point = {
    row = v_row - 1,
    col = v_col,
  }
  if c_row > v_row or (c_row == v_row and c_col >= v_col) then
    local _start_point = start_point
    start_point = end_point
    end_point = _start_point
  end
  return start_point, end_point
end

--- @param config TreesitterTextobject.Spec
function M.select(config)
  local start_row, start_col, end_row, end_col = M.range(config)
  if start_row then
    update_visual(start_row + 1, start_col, end_row + 1, end_col - 1)
  end
end

function M.range(config)
  local node = M.get_node(config)
  if node then
    return node:range()
  end
end

function M.get_node(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, config.language):parse()[1]
  local query = vim.treesitter.query.get(config.language, config.scm)
  if query == nil then
    return
  end
  local start_point, end_point = get_visual_points()
  local nodes = {}
  for id, node, _, _ in query:iter_captures(tree:root(), bufnr) do
    if query.captures[id] == config.query then
      nodes[#nodes + 1] = node
      local s = get_node_relative_point(node, start_point)
      if s == NODE_CONTAIN_POINT then
        start_point.node = node
      end
      local e = get_node_relative_point(node, end_point)
      if e == NODE_CONTAIN_POINT then
        end_point.node = node
      end
      if e == NODE_AFTER_POINT then
        break
      end
    end
  end

  local target_node
  if start_point.node then
    target_node = start_point.node
    if end_point.node then
      target_node = start_point.cursor and start_point.node or end_point.node
    end
  else
    if end_point.node then
      target_node = end_point.node
    else
      target_node = nodes[#nodes]
    end
  end
  if not target_node then
    return
  end
  return target_node
end

return M
