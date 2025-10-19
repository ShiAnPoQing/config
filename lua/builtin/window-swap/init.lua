local M = {}

local Tree = {}

function Tree:init()
  local layout = vim.fn.winlayout()

  self.tree = { type = "root", nodes = {} }
  self.queue = {
    function()
      self:build(self.tree, { layout })
    end,
  }
end

function Tree:build(parent, layouts)
  for _, layout in ipairs(layouts) do
    local child = {
      type = layout[1],
      nodes = {},
      parent = parent,
      index = #parent.nodes + 1,
    }
    table.insert(parent.nodes, child)
    if type(layout[2]) == "number" then
      child.win = layout[2]
    elseif type(layout[2]) == "table" then
      table.insert(self.queue, function()
        self:build(child, layout[2])
      end)
    end
  end
end

function Tree:build_tree()
  while #self.queue > 0 do
    self.queue[1]()
    table.remove(self.queue, 1)
  end
end

function Tree:get_node(winnr)
  local function run(tree)
    if tree.win == winnr then
      return tree
    end

    for _, value in ipairs(tree.nodes) do
      local node = run(value)
      if node then
        return node
      end
    end
  end

  return run(self.tree)
end

local function swap(parent_node, current_node, index)
  local swap_node = parent_node.nodes[index]
  if swap_node then
    vim.cmd(index .. "wincmd x")
    vim.api.nvim_set_current_win(current_node.win)
  end
end

--- @param direction 1 |-1
function M.window_swap(direction)
  Tree:init()
  Tree:build_tree()
  local current_win = vim.api.nvim_get_current_win()
  local current_node = Tree:get_node(current_win)
  local parent_node = current_node.parent
  local count = vim.v.count1

  if direction == 1 then
    local absolute_index = current_node.index + count
    if absolute_index > #parent_node.nodes then
      absolute_index = absolute_index - #parent_node.nodes
    end
    swap(parent_node, current_node, absolute_index)
  else
    local absolute_index = current_node.index - count
    if absolute_index < 1 then
      absolute_index = absolute_index + #parent_node.nodes
    end
    swap(parent_node, current_node, absolute_index)
  end
end

return M
