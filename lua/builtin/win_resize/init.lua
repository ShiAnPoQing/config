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

local function is_last_node(node)
  return node.index == #node.parent.nodes
end

--- @param type "decrease" | "increase"
--- @param direction "vertical" | "horizontal"
function M.resize(type, direction)
  local current_win = vim.api.nvim_get_current_win()
  Tree:init()
  Tree:build_tree()

  local current_node = Tree:get_node(current_win)
  local size = 5
  size = type == "decrease" and -size or size

  if direction == "vertical" then
    if is_last_node(current_node) then
      local str_size = (-size > 0 and "+" or "") .. -size
      vim.cmd("resize" .. str_size)
    else
      local str_size = (size > 0 and "+" or "") .. size
      vim.cmd("resize" .. str_size)
    end
  end

  if direction == "horizontal" then
    if is_last_node(current_node) then
      local str_size = (-size > 0 and "+" or "") .. -size
      vim.cmd("vert resize" .. str_size)
    else
      local str_size = (size > 0 and "+" or "") .. size
      vim.cmd("vert resize" .. str_size)
    end
    return
  end
end

return M
