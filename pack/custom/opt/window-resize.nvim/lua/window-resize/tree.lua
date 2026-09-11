local Node = require("window-resize.node")
local Tree = setmetatable({}, { __index = Node})


local function _build(layouts)
  local queue = {

  }
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
        _build(child, layout[2])
      end)
    end
  end
end

function Tree:new()
  local o = Node.new(self)
  local layout = vim.fn.winlayout()
  o.tree = { type = "root", nodes = {} }
  o.queue = {
    function()
      _build(o.tree, { layout })
    end,
  }
  while #o.queue > 0 do
    o.queue[1]()
    table.remove(o.queue, 1)
  end
  return o
end


return Tree
