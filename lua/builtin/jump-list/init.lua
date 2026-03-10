local M = {}

local lock
local max = 0

local jumps_history = {}
local JUMP_NEW_KEY = "<C-i>"
local JUMP_OLD_KEY = "<C-o>"

--- @param direction 1 | -1
--- @param only_current_buf? boolean
local function jump_buffer(direction, only_current_buf)
  local jumplist, current_jump = unpack(vim.fn.getjumplist())
  current_jump = current_jump + 1
  if #jumplist == 0 then
    return
  end
  local current_buf = vim.api.nvim_get_current_buf()
  local jump_key
  local range = {}

  if direction > 0 then
    jump_key = JUMP_NEW_KEY
    if current_jump + 1 > #jumplist then
      return
    end
    range = vim.fn.range(current_jump + 1, #jumplist, 1)
  else
    jump_key = JUMP_OLD_KEY
    range = vim.fn.range(current_jump - 1, 1, -1)
  end

  local condition = function(bufnr)
    if only_current_buf then
      return bufnr == current_buf
    else
      return bufnr ~= current_buf
    end
  end

  for _, i in ipairs(range) do
    local bufnr = jumplist[i].bufnr
    if condition(bufnr) then
      vim.api.nvim_feedkeys(
        tostring(math.abs(i - current_jump)) .. vim.api.nvim_replace_termcodes(jump_key, true, false, true),
        "nx",
        false
      )
      break
    end
  end
end

local function create_node(jumplist, range, current_buf)
  local node
  local prev_index
  for _, i in ipairs(range) do
    local jump = jumplist[i]
    local bufnr = jump.bufnr

    if not node then
      if bufnr ~= current_buf then
        node = {
          bufnr = bufnr,
          jumplist = { jump },
        }
      end
    else
      if node.bufnr == bufnr then
        node.jumplist[#node.jumplist + 1] = jump
      else
        return node, prev_index
      end
    end
    prev_index = i
  end

  return node, range[#range]
end

local function feedkey(jump, current_jump, jump_key, offset)
  local count = math.abs(jump - current_jump) - offset
  vim.api.nvim_feedkeys(tostring(count) .. vim.api.nvim_replace_termcodes(jump_key, true, false, true), "nx", false)
end

local function exsit_node_history(history_node, node)
  local exsit = true
  local clean

  for i, history_jump in ipairs(history_node.jumplist) do
    local jump = node.jumplist[i]
    if not jump then
      exsit = false
    else
      if history_jump.col ~= jump.col or history_jump.lnum ~= jump.lnum then
        exsit = false
      elseif history_jump.col == jump.col and history_jump.lnum == jump.lnum then
        clean = true
      end
    end
  end

  if exsit then
    clean = false
  end

  return exsit, clean
end

local function find_history_node(history, node)
  local find_node
  local clean_node

  for _, history_node in ipairs(history) do
    local exsit, clean = exsit_node_history(history_node, node)
    if exsit then
      find_node = history_node
    else
      if clean then
        clean_node = history_node
      end
    end
  end

  return find_node, clean_node
end

local function update_current_node_history(current_jump)
  if not current_jump then
    return
  end

  local current_history = jumps_history[current_jump.bufnr]
  if not current_history then
    return
  end

  for _, current_history_node in ipairs(current_history) do
    for i, j in ipairs(current_history_node.jumplist) do
      if j.bufnr == current_jump.bufnr and j.lnum == current_jump.lnum and j.col == current_jump.col then
        current_history_node.current = i
      end
    end
  end
end

local function push_node_history(history, node)
  node.current = 1
  node.index = #history + 1
  history[#history + 1] = node
end

local function get_next_node(node)
  if not jumps_history[node.bufnr] then
    local history = {}
    jumps_history[node.bufnr] = history
    push_node_history(history, node)
    return node
  end

  local history = jumps_history[node.bufnr]
  local find_node, clean_node = find_history_node(history, node)

  if find_node then
    return find_node
  end

  if clean_node then
    table.remove(history, clean_node.index)
  end
  push_node_history(history, node)
  return node
end

local function _jump_buffer(direction)
  local jumplist, current_jump_index = unpack(vim.fn.getjumplist())
  current_jump_index = current_jump_index + 1
  if #jumplist == 0 then
    return
  end
  local current_buf = vim.api.nvim_get_current_buf()
  local jump_key
  local range = {}

  if direction > 0 then
    jump_key = JUMP_NEW_KEY
    if current_jump_index + 1 > #jumplist then
      return
    end
    range = vim.fn.range(current_jump_index + 1, #jumplist, 1)
  else
    jump_key = JUMP_OLD_KEY
    range = vim.fn.range(current_jump_index - 1, 1, -1)
  end

  local node, node_jump_index = create_node(jumplist, range, current_buf)
  if not node then
    return
  end
  update_current_node_history(jumplist[current_jump_index])
  local next_node = get_next_node(node)
  feedkey(node_jump_index, current_jump_index, jump_key, #next_node.jumplist - next_node.current)
end

function M.switch_lock(dir)
  lock = not lock
  M.jump(dir)
end

function M.jump(dir)
  if not lock then
    if dir == -1 then
      vim.api.nvim_feedkeys(vim.v.count1 .. vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "nx", false)
    elseif dir == 1 then
      vim.api.nvim_feedkeys(vim.v.count1 .. vim.api.nvim_replace_termcodes("<C-i>", true, false, true), "nx", false)
    end
  else
    jump_buffer(dir, lock)
  end
end

function M.jump_buffer(dir)
  jump_buffer(dir)
end

function M._jump_buffer(dir)
  _jump_buffer(dir)
end

return M
