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

function Tree:is_last_node()
  if not self.find then
    return
  end
  local is
  for i, value in ipairs(self.find.nodes) do
    if value.win == self.current_win then
      is = i == #self.find.nodes
    end
  end

  return is
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

--- @return boolean
local function is_last_node(node)
  return node.index == #node.parent.nodes
end

local function set_width(win, get_width)
  local width = vim.api.nvim_win_get_width(win)
  vim.api.nvim_win_set_width(win, get_width(width))
end

local function set_height(win, get_height)
  local height = vim.api.nvim_win_get_height(win)
  vim.api.nvim_win_set_height(win, get_height(height))
end
--- @class WindowResizeOpts
--- @field type "decrease" | "increase"
--- @field direction "vertical" | "horizontal"
--- @field size? number

--- @param opts WindowResizeOpts
function M.window_resize(opts)
  local current_win = vim.api.nvim_get_current_win()
  Tree:init()
  Tree:build_tree()

  local current_node = Tree:get_node(current_win)
  local parent = current_node.parent

  local size = opts.size or 5
  if opts.type == "decrease" then
    size = -size
  end

  if opts.direction == "vertical" then
    if parent.type == "row" then
      if is_last_node(parent) then
        local prev = parent.parent.nodes[parent.index - 1]
        local win = prev.win == nil and prev.nodes[1].win or prev.win
        set_height(win, function(height)
          return height + size
        end)
      else
        vim.cmd("resize " .. (size > 0 and "+" .. size or size))
      end
    elseif parent.type == "col" then
      if is_last_node(current_node) then
        local prev = parent.nodes[current_node.index - 1]
        set_height(prev.win, function(height)
          return height + size
        end)
      else
        vim.cmd("resize " .. (size > 0 and "+" .. size or size))
      end
    end
  elseif opts.direction == "horizontal" then
    if parent.type == "col" then
      if is_last_node(parent) then
        local prev = parent.parent.nodes[parent.index - 1]
        local win = prev.win == nil and prev.nodes[1].win or prev.win
        set_width(win, function(width)
          return width + size
        end)
      else
        vim.cmd("vertical resize " .. (size > 0 and "+" .. size or size))
      end
    elseif parent.type == "row" then
      if is_last_node(current_node) then
        local prev = parent.nodes[current_node.index - 1]
        set_width(prev.win, function(width)
          return width + size
        end)
      else
        vim.cmd("vertical resize " .. (size > 0 and "+" .. size or size))
      end
    end
  end
end

function M.setup(opts) end

return M

--[[
" 增加窗口高度
:resize +5
:res +5

" 减少窗口高度
:resize -5
:res -5

" 设置窗口高度
:resize 20
:res 20

" 增加窗口宽度
:vertical resize +10

" 减少窗口宽度
:vertical resize -10

" 设置窗口宽度
:vertical resize 80



<C-w>+    " 增加高度
<C-w>-    " 减少高度
<C-w>=    " 平均分配高度

<C-w>>    " 增加宽度
<C-w><    " 减少宽度
<C-w>|    " 最大化宽度

<C-w>_    " 最大化高度
<C-w>|    " 最大化宽度
<C-w>=    " 平均分配所有窗口


-- 获取当前窗口
local win_id = vim.api.nvim_get_current_win()

-- 获取窗口大小
local width = vim.api.nvim_win_get_width(win_id)
local height = vim.api.nvim_win_get_height(win_id)

-- 获取窗口位置和大小
local config = vim.api.nvim_win_get_config(win_id)
print("宽度:", config.width)
print("高度:", config.height)

-- 设置窗口宽度
vim.api.nvim_win_set_width(win_id, 80)

-- 设置窗口高度
vim.api.nvim_win_set_height(win_id, 20)

-- 设置窗口配置
vim.api.nvim_win_set_config(win_id, {
  width = 80,
  height = 20,
  row = 0,
  col = 0,
})
--]]
