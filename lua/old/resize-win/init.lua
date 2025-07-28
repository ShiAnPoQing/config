local M = {}

--- @class Option
--- @field direction "left" | "right" | "down" | "up"

local Tree = {}

function Tree:init()
  local layout = vim.fn.winlayout()

  self.tree = { type = "root", nodes = {} }
  self.queue = { function()
    self:build_tree(self.tree, { layout })
  end }
  self.current_win = vim.api.nvim_get_current_win()
end

function Tree:build_tree(parent, layouts)
  for index, layout in ipairs(layouts) do
    local child = {
      type = layout[1],
      nodes = {},
      parent = parent,
      index = #parent.nodes + 1
    }
    table.insert(parent.nodes, child)
    if type(layout[2]) == "number" then
      child.win = layout[2]
      if child.win == self.current_win then
        self.find = child
      end
    elseif type(layout[2]) == "table" then
      table.insert(self.queue, function()
        self:build_tree(child, layout[2])
      end)
    end
  end
end

function Tree:start_build_tree()
  while #self.queue > 0 do
    self.queue[1]()
    table.remove(self.queue, 1)
  end
end

local function find_left(source)
  if not source or not source.parent then
    return
  end

  local parent = source.parent
  local left = parent.nodes[source.index - 1]
  if parent.type == "row" and left then
    return left
  else
    return find_left(parent)
  end
end

local function find_right(source)
  if not source or not source.parent then
    return
  end

  local parent = source.parent
  local right = parent.nodes[source.index + 1]
  if parent.type == "row" and right then
    return right
  else
    return find_right(parent)
  end
end

local function find_above(source)
  if not source or not source.parent then
    return
  end

  local parent = source.parent
  local above = parent.nodes[source.index - 1]
  if parent.type == "col" and above then
    return above
  else
    return find_above(parent)
  end
end

local function find_below(source)
  if not source or not source.parent then
    return
  end

  local parent = source.parent
  local below = parent.nodes[source.index + 1]
  if parent.type == "col" and below then
    return below
  else
    return find_below(parent)
  end
end

local function resize_up(below, callback)
  local above = find_above(below)

  if above then
    local winnr = vim.fn.win_id2win(above.win)
    local width = vim.fn.winheight(winnr)
    if width > 1 then
      vim.cmd(winnr .. "resize -3")
      callback()
    else
      resize_up(above, function()
        vim.cmd(winnr .. "resize -3")
        callback()
      end)
    end
  end

  return above
end

local function resize_down(above, callback)
  local below = find_below(above)

  if below then
    local winnr = vim.fn.win_id2win(below.win)
    local width = vim.fn.winheight(winnr)
    if width > 1 then
      vim.cmd(winnr .. "resize +3")
      callback()
    else
      resize_down(below, function()
        vim.cmd(winnr .. "resize -3")
        callback()
      end)
    end
  end

  return below
end

--- @param opt Option
function M.resize_win(opt)
  Tree:init()
  Tree:start_build_tree()

  if opt.direction == "right" then
    vim.cmd("vertical resize +3")
  end

  if opt.direction == "left" then
    local left = find_left(Tree.find)
    if left then
      local winnr = vim.fn.win_id2win(left.win)
      vim.cmd('vertical ' .. winnr .. "resize -3")
    else
      vim.cmd("vertical resize -3")
    end
  end

  if opt.direction == "up" then
    local above = resize_up(Tree.find, function() end)
    if not above then
      vim.cmd("resize -3")
    end
  end

  if opt.direction == "down" then
    local below = find_below(Tree.find)
    if below then
      local winnr = vim.fn.win_id2win(below.win)
      local height = vim.fn.winheight(winnr)
      if height > 1 then
        vim.cmd("resize +3")
      end
    else
      vim.cmd("resize -3")
    end
  end
end

return M
