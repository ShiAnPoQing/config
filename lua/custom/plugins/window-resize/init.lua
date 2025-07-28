local M = {}

function M.window_resize() end

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
