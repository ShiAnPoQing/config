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

local function get_node_type(node, v_start_row, v_start_col, v_end_row, v_end_col)
  local start_row, start_col, end_row, end_col = node:range()
  local type
  if (start_row < v_start_row) or (start_row == v_start_row and start_col <= v_start_col) then
    if end_row < v_start_row or (end_row == v_start_row and end_col <= v_start_col) then
      type = "before"
    elseif end_row > v_end_row or (end_row == v_end_row and end_col >= v_end_col) then
      type = "contain"
    elseif end_row < v_end_row or (end_row == v_end_row and end_col < v_end_col) then
      type = "before contain"
    end
  elseif (end_row > v_end_row) or (end_row == v_end_row and end_col >= v_end_col) then
    if start_row > v_end_row or (start_row == v_end_row and start_col >= v_end_col) then
      type = "after"
    elseif start_row < v_start_row or (start_row == v_start_row and start_col <= v_start_col) then
      type = "contain"
    elseif start_row > v_start_row or (start_row == v_start_row and start_col > v_start_col) then
      type = "after contain"
    end
  end

  return type
end

local function find_contain(node_datas)
  local target_node = vim.iter(node_datas):rev():find(function(node_data)
    return node_data.type == "contain"
  end)
  if target_node then
    return target_node.node
  end
end

local function get_candidate_nodes(name, query, root, bufnr, v_start_row, v_start_col, v_end_row, v_end_col)
  local node_datas = {}

  for id, node, _, _ in query:iter_captures(root, bufnr) do
    if query.captures[id] == name and not node:equal(root) then
      local type = get_node_type(node, v_start_row, v_start_col, v_end_row, v_end_col)
      table.insert(node_datas, { node = node, type = type })
      if type == "after" or type == "after contain" then
        break
      end
    end
  end

  return node_datas
end

--- @param query vim.treesitter.Query
local function get_deep_contain_node(name, query, root, bufnr, v_start_row, v_start_col, v_end_row, v_end_col)
  local target_node

  for id, node, _, _ in query:iter_captures(root, bufnr) do
    if query.captures[id] == name and not node:equal(root) then
      local type = get_node_type(node, v_start_row, v_start_col, v_end_row, v_end_col)
      if type == "contain" then
        target_node = node
        break
      end
    end
  end

  if target_node then
    return get_deep_contain_node(name, query, target_node, bufnr, v_start_row, v_start_col, v_end_row, v_end_col)
  else
    return root
  end
end

--- @param query vim.treesitter.Query
local function textobject(config, query, bufnr, tree)
  local mode = vim.api.nvim_get_mode().mode

  if not is_visual_mode(mode) then
    vim.api.nvim_feedkeys("v", "nx", false)
    M.textobject(config)
    return
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
  local v_start_row, v_start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local v_end_row, v_end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local root = tree:root()
  local node_datas =
    get_candidate_nodes(config.query, query, root, bufnr, v_start_row - 1, v_start_col, v_end_row - 1, v_end_col + 1)
  local target_node = find_contain(node_datas)
  if target_node then
    target_node = get_deep_contain_node(
      config.query,
      query,
      target_node,
      bufnr,
      v_start_row - 1,
      v_start_col,
      v_end_row - 1,
      v_end_col + 1
    )
  else
    local last = node_datas[#node_datas]
    if last then
      target_node = last.node
    end
  end
  if not target_node then
    vim.api.nvim_feedkeys("gv", "n", false)
    return
  end
  local start_row, start_col, end_row, end_col = target_node:range()
  visual(start_row + 1, start_col, end_row + 1, end_col - 1)
end

--- @param config? TreesitterTextobject.textobject
function M.textobject(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, config.language):parse()[1]
  local query = vim.treesitter.query.get(config.language, config.scm)

  if query == nil then
    return
  end
  textobject(config, query, bufnr, tree)
end

return M
