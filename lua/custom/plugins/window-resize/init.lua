local M = {}

local Tree = {}

function Tree:init()
  local layout = vim.fn.winlayout()

  self.tree = { type = "root", nodes = {} }
  self.queue = {
    function()
      self:build_tree(self.tree, { layout })
    end,
  }
  self.current_win = vim.api.nvim_get_current_win()
end

function Tree:build_tree(parent, layouts)
  for index, layout in ipairs(layouts) do
    local child = {
      type = layout[1],
      nodes = {},
      parent = parent,
      index = #parent.nodes + 1,
    }
    table.insert(parent.nodes, child)
    if type(layout[2]) == "number" then
      child.win = layout[2]
      if child.win == self.current_win then
        self.find = parent
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

function Tree:get_next()
  if not self.find then
    return
  end
  local next
  for i, value in ipairs(self.find.nodes) do
    if value.win == self.current_win and #self.find.nodes > i then
      next = self.find.nodes[i + 1]
    end
  end
  return next
end

function Tree:get_prev()
  if not self.find then
    return
  end
  local prev
  for i, value in ipairs(self.find.nodes) do
    if value.win == self.current_win then
      if i > 1 then
        prev = self.find.nodes[i - 1]
      end
    end
  end
  return prev
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

local function set_width(win, get_width)
  local width = vim.api.nvim_win_get_width(win)
  vim.api.nvim_win_set_width(win, get_width(width))
end

local function set_height(win, get_height)
  local height = vim.api.nvim_win_get_height(win)
  vim.api.nvim_win_set_height(win, get_height(height))
end

--- @class WindowResizeOpts
--- @field type "vertical decrease" | "horizontal decrease" | "vertical increase" | "horizontal increase"

--- @param opts WindowResizeOpts
function M.window_resize(opts)
  Tree:init()
  Tree:start_build_tree()
  local prev = Tree:get_prev()
  local is_last = Tree:is_last_node()

  if opts.type == "vertical decrease" then
    if is_last and prev then
      set_height(prev.win, function(height)
        return height - 5
      end)
    else
      vim.cmd("resize -5")
    end
  elseif opts.type == "vertical increase" then
    if is_last and prev then
      set_height(prev.win, function(height)
        return height + 5
      end)
    else
      vim.cmd("resize +5")
    end
  elseif opts.type == "horizontal decrease" then
    if is_last and prev then
      set_width(prev.win, function(width)
        return width - 5
      end)
    else
      vim.cmd("vertical resize -5")
    end
  elseif opts.type == "horizontal increase" then
    if is_last and prev then
      set_width(prev.win, function(width)
        return width + 5
      end)
    else
      vim.cmd("vertical resize +5")
    end
  end
end

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
