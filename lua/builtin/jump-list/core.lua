local M = {}

local history = {}
local JUMP_NEW_KEY = vim.api.nvim_replace_termcodes("<C-i>", true, false, true)
local JUMP_OLD_KEY = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)

local function get_range(direction, jumplist, current_jump_index)
  local current_jump
  local range_start
  local jumplist_range
  if direction < 0 then
    jumplist_range = vim.fn.range(current_jump_index, #jumplist, 1)
  else
    jumplist_range = vim.fn.range(current_jump_index, 1, -1)
  end

  for i, index in ipairs(jumplist_range) do
    local jump = jumplist[index]
    if not current_jump then
      if index == current_jump_index then
        current_jump = jump
      end
    else
      if jump.bufnr ~= current_jump.bufnr then
        range_start = jumplist_range[i - 1]
        break
      end
    end
  end

  if not range_start then
    range_start = jumplist_range[#jumplist_range]
  end

  local range
  if direction > 0 then
    range = vim.fn.range(range_start, #jumplist, 1)
  else
    range = vim.fn.range(range_start, 1, -1)
  end

  return range
end

local function get_next_node(start, range, jumplist)
  if start > #range then
    return
  end
  range = vim.list_slice(range, start)
  local node = {
    current = 1,
    jumps = {},
    bufnr = nil,
    index = nil,
  }

  local next_start
  for i, index in ipairs(range) do
    local jump = jumplist[index]
    if not node.bufnr then
      node.bufnr = jump.bufnr
      node.index = index
    end
    if jump.bufnr == node.bufnr then
      node.jumps[#node.jumps + 1] = jump
    else
      next_start = i
      break
    end
  end

  if not next_start then
    next_start = #range + 1
  end

  next_start = next_start + start - 1

  return node, next_start
end

local function update_node(node)
  local row = vim.fn.line(".")
  local jumps = node.jumps
  local min_offset
  local current_jump_index
  for i, jump in ipairs(jumps) do
    local offset = math.abs(jump.lnum - row)
    if not min_offset then
      min_offset = offset
      current_jump_index = i
    else
      if offset < min_offset then
        min_offset = offset
        current_jump_index = i
      end
    end
  end
  node.current = current_jump_index
end

local function find_node(nodes, node)
  local delete_node_indexs = {}
  local find
  for i, n in ipairs(nodes) do
    local find_count = 0
    for _, jump in ipairs(n.jumps) do
      for _, j in ipairs(node.jumps) do
        if j.lnum == jump.lnum and j.col == jump.col then
          find_count = find_count + 1
        end
      end
    end
    if find_count == #node.jumps and #n.jumps == #node.jumps then
      find = n
    elseif find_count > 0 then
      delete_node_indexs[#delete_node_indexs + 1] = i
    end
  end

  for _, index in ipairs(delete_node_indexs) do
    table.remove(nodes, index)
  end

  return find
end

local function get_next_count_node(count, start, range, jumplist)
  local prev_node
  local prev_start = start
  local function run(s)
    local next_node, next_start = get_next_node(s, range, jumplist)
    if not next_node then
      return prev_node, prev_start
    end
    prev_node = next_node
    count = count - 1

    if count == 0 then
      return next_node, next_start
    else
      return run(next_start)
    end
  end

  return run(start)
end

function M.jump(direction)
  local count = vim.v.count1
  if direction < 0 then
    vim.api.nvim_feedkeys(JUMP_OLD_KEY .. JUMP_NEW_KEY, "nx", false)
  end
  local jumplist, current_jump_index = unpack(vim.fn.getjumplist())
  current_jump_index = current_jump_index + 1
  if direction > 0 and current_jump_index > #jumplist then
    return
  end

  if #jumplist == 0 then
    return
  end

  local jump_key
  if direction > 0 then
    jump_key = JUMP_NEW_KEY
  else
    jump_key = JUMP_OLD_KEY
  end
  local range = get_range(direction, jumplist, current_jump_index)
  local current_node, next_start = get_next_node(1, range, jumplist)
  local next_node = get_next_count_node(count, next_start, range, jumplist)

  if not next_node then
    return
  end

  if not history[current_node.bufnr] then
    history[current_node.bufnr] = { current_node }
    update_node(current_node)
    -- vim.print("没有 current node 历史", #current_node.jumps)
  else
    local find = find_node(history[current_node.bufnr], current_node)
    if find then
      update_node(find)
      -- vim.print("find有 current node 历史")
    else
      table.insert(history[current_node.bufnr], current_node)
      update_node(current_node)
      -- vim.print("find没有 current node 历史", #current_node.jumps)
    end
  end

  local jump_count
  if not history[next_node.bufnr] then
    history[next_node.bufnr] = { next_node }
    jump_count = math.abs(next_node.index - current_jump_index)
    -- vim.print("没有 next node 历史", count)
  else
    local find = find_node(history[next_node.bufnr], next_node)
    if find then
      local index = next_node.index
      jump_count = math.abs(index - current_jump_index) + (#next_node.jumps - next_node.current)
      -- vim.print("find 有 next node 历史", count)
    else
      table.insert(history[current_node.bufnr], current_node)
      jump_count = math.abs(next_node.index - current_jump_index)
      -- vim.print("find 没有 next node 历史", count)
    end
  end
  if jump_count and jump_count > 0 then
    vim.api.nvim_feedkeys(jump_count .. jump_key, "nx", false)
  end
end

return M
