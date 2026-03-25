local U = require("reasonable-scroll.util")
local M = {}

local function get_max_sideoffset(count, wininfo, sidescrolloff)
  return math.min(count, wininfo.width - wininfo.textoff - 2 * sidescrolloff - 1)
end

local function get_max_offset(count, height, scrolloff)
  return math.min(count, height - 2 * scrolloff - 1)
end

local function is_cursor_in_virtualedit()
  return vim.fn.virtcol(".") > vim.fn.col(".")
end

-- 光标在非虚拟编辑区域，增加 offset 逻辑
local function scroll_viewport_left_none_virtualedit(count)
  if count == 0 then
    U.feedkeys("zs") -- 提前返回，性能优化
    return
  end
  local sidescrolloff = U.get_sidescrolloff()
  local wininfo = U.get_wininfo()
  --  修正 offset
  --  因为 sidescrolloff 存在，所以 count 必须修正为相对于sidescrolloff 的偏移量
  count = get_max_sideoffset(count, wininfo, sidescrolloff)
  local offset = math.max(count - sidescrolloff, 0)
  U.feedkeys("zs" .. (offset > 0 and offset .. "zh" or ""))
end

local function scroll_viewport_left_virtualedit_no_offset(real_wincol)
  if real_wincol <= 0 then
    return
  end
  U.feedkeys(real_wincol .. "zl")
end

-- 光标在虚拟编辑区域，修正原始行为，增加 offset 逻辑
local function scroll_viewport_left_virtualedit(count, virt_col)
  local wininfo = U.get_wininfo()
  local sidescrolloff = U.get_sidescrolloff()
  if count == 0 then
    return scroll_viewport_left_virtualedit_no_offset(virt_col - wininfo.leftcol - 1 - sidescrolloff)
  end
  count = get_max_sideoffset(count, wininfo, sidescrolloff)
  local offset = math.max(count - sidescrolloff, 0)
  -- 光标移动到视口左侧需要 zl 滚动的列数
  -- 计算出实际滚动的数量
  local compute = virt_col - wininfo.leftcol - 1 - sidescrolloff - offset
  local keys
  if compute < 0 then
    -- 实际滚动的数量为负数，说明需要向右滚动
    keys = math.abs(compute) .. "zh"
  elseif compute > 0 then
    -- 实际滚动的数量为正数，说明需要向左滚动
    keys = math.abs(compute) .. "zl"
  elseif compute == 0 then
    return
  end
  U.feedkeys(keys)
end

local function scroll_viewport_right_none_virtualedit(count)
  if count == 0 then
    U.feedkeys("ze")
    return
  end
  U.feedkeys("ze")
  local sidescrolloff = U.get_sidescrolloff()
  local wininfo = U.get_wininfo()
  count = get_max_sideoffset(count, wininfo, sidescrolloff)
  if wininfo.leftcol == 0 then
    return
  end
  local offset = count - sidescrolloff
  if offset <= 0 then
    return
  end
  U.feedkeys(offset .. "zl")
end

local function scroll_viewport_right_virtualedit_no_offset()
  local wincol = vim.fn.wincol()
  local width = vim.fn.winwidth(0)
  local sidescrolloff = U.get_sidescrolloff()
  local real_wincol = width - wincol - sidescrolloff
  if real_wincol <= 0 then
    return
  end
  U.feedkeys(real_wincol .. "zh")
end

local function scroll_viewport_right_virtualedit(count)
  if count == 0 then
    scroll_viewport_right_virtualedit_no_offset()
    return
  end
  local wincol = vim.fn.wincol()
  local width = vim.fn.winwidth(0)
  local sidescrolloff = U.get_sidescrolloff()
  local real_wincol = width - wincol - sidescrolloff
  local offset = math.max(count - sidescrolloff, 0)
  -- 光标移动到视口左侧需要 zl 滚动的列数
  -- 计算出实际滚动的数量
  local compute = real_wincol - offset
  if compute < 0 then
    U.feedkeys(math.abs(compute) .. "zl")
  elseif compute > 0 then
    U.feedkeys(math.abs(compute) .. "zh")
  elseif compute == 0 then
    return
  end
end

-- zt 默认行为如下:
--   1. 支持 count，count 为绝对行数
--   2. 将当前光标位置滚动到视口顶部(一定能滚动到)
-- 预期行为
--   1. 支持 count，count 为相对于视口顶部的偏移量
-- 思路： zt + offset <C-y>
function M.scroll_viewport_top()
  local count = vim.v.count
  if count == 0 then
    -- <Ignore> 忽略 count，阻止原生行为
    U.feedkeys("<Ignore>zt")
    return
  end
  local scrolloff = U.get_scrolloff()
  local height = vim.fn.winheight(0)
  local offset = get_max_offset(count, height, scrolloff) - scrolloff
  U.feedkeys("<Ignore>zt" .. (offset > 0 and offset .. "<C-y>" or ""))
end

-- zb 默认行为如下:
--   1. 支持 count，count 为绝对行数
--   2. 将当前光标位置滚动到视口底部(可能滚不到)
-- 预期行为
--   1. 支持 count，count 为相对于视口底部的偏移量
--   2. 若不能将光标位置滚动到视口底部，则取消 count 偏移量
-- 思路：
--- 1. 先 zb (因为 fold 折叠等原因导致不可提前计算 offset)
--- 2. 判断是否需要 offset 逻辑
--- 3. 需要则添加 offset 逻辑，反之退出
function M.scroll_viewport_bottom()
  -- 滚动之前存储 count offset
  local count = vim.v.count
  --- <Ignore> 忽略 count，阻止原生行为
  U.feedkeys("<Ignore>zb")
  if count == 0 then
    return
  end
  local scrolloff = U.get_scrolloff()
  local winline = vim.fn.winline()
  local height = vim.fn.winheight(0)
  count = get_max_offset(count, height, scrolloff)
  -- 判断是否滚动到 viewport 底部，如果不能 offset 就结束
  if winline < height - scrolloff then
    return
  end
  local offset = count - scrolloff
  if offset <= 0 then
    return
  end
  U.feedkeys(offset .. "<C-e>")
end
-- zs 默认行为如下:
--   1. 不支持 count
--   2. 光标在非虚拟编辑区域，将当前光标位置滚动到视口左侧(一定滚得到)
--   3. 光标在虚拟编辑区域，将当前行尾滚动到视口左侧，而不是将光标虚拟编辑列滚动到视口左侧
-- 预期实现：
--   1. 支持 count，count 为相对于视口左侧的偏移量
--   2. 光标在虚拟编辑区域，将光标虚拟编辑列滚动到视口左侧，而不是行尾
-- 思路： 滚动之前直接计算好 offset，再滚动
function M.scroll_viewport_left()
  local count = vim.v.count
  -- 判断是否处在虚拟编辑区域
  if is_cursor_in_virtualedit() then
    return scroll_viewport_left_none_virtualedit(count)
  end
  return scroll_viewport_left_virtualedit(count, vim.fn.virtcol("."))
end

-- ze 默认行为如下:
--   1. 不支持 count
--   2. 将当前光标位置滚动到视口右侧(可能滚不到)
--
-- 预期实现：
--   1. 支持 count，count 为相对于视口右侧的偏移量
--   2. 若不能将光标位置滚动到视口右侧，则取消 count 偏移量
-- 思路：
--  1. 先 ze (因为提前计算，不好得出光标位置是否能滚动到视口右侧)
--  2. 判断光标位置是否处于视口右侧
--  3. 决定是否取消 count 偏移量
function M.scroll_viewport_right()
  if is_cursor_in_virtualedit() then
    return scroll_viewport_right_virtualedit(vim.v.count)
  else
    return scroll_viewport_right_none_virtualedit(vim.v.count)
  end
end

--- 无原生行为
--- 计算光标相对于视口中心的偏移量
--  winwidth() 函数包含 textoff，不可用
function M.scroll_viewport_vertical_center()
  local wininfo = U.get_wininfo()
  local offset = math.ceil((wininfo.width - wininfo.textoff) / 2) - (vim.fn.virtcol(".") - wininfo.leftcol)
  if offset == 0 then
    return
  end
  local key
  if offset == 0 then
    return
  elseif offset < 0 then
    key = -offset .. "zl"
  else
    key = offset .. "zh"
  end
  U.feedkeys(key)
end

return M
