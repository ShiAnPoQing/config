local M = {}
-- 寄存器：register-functions
--   getreg() 获取寄存器的内容
--   getreginfo() 获取寄存器的信息
--   getregtype() 获取寄存器的类型
--   setreg() 设置寄存器的内容和类型
--   reg_executing() 返回正在执行的寄存器名称
--   reg_recording() 返回正在记录的寄存器名称
local registers = {
  -- '"', -- 未命名寄存器
  -- '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',                -- 数字寄存器
  'a', 'b', 'c' --, 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  -- 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', -- 命名寄存器
  -- '-',      -- 小删除寄存器
  -- '*', '+', -- 系统剪贴板寄存器
  -- '/',      -- 搜索寄存器
  -- ':',      -- 命令行寄存器
  -- '%', '#', -- 当前和上一个文件名
  -- '='       -- 表达式寄存器
}

local Extmark = {
  extmarks = {},
  ns_id = vim.api.nvim_create_namespace("register-control"),
}

local Float = {
  buf = nil,
  win = nil
}

local BufAttch = {
  had_stop = nil
}

local OnAddLine = {}

local OnDelLine = {
  type = "",
}

local SpecialPaste = {
  isPaste = nil,
}

local function get_all_register()
  local results = {}
  for _, reg in ipairs(registers) do
    local content = vim.fn.getreg(reg)
    table.insert(results, {
      name = reg,
      content = content
    })
  end

  return results
end

local function create_float_win(buf)
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  local win_height = math.ceil(height * 0.6)
  local win_width = math.ceil(width * 0.6)

  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = require("custom.style.float.border").border2,
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  require("utils.float.win-move").load(buf, {})

  return win
end

function Float:create_buf()
  if self.buf then return end

  self.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(self.buf, "[Registers]")
  vim.api.nvim_buf_set_option(self.buf, "buftype", "acwrite")

  local augroup = vim.api.nvim_create_augroup('RegisterBuffer' .. self.buf, { clear = true })
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = self.buf,
    group = augroup,
    callback = function()
      print("xing")
    end
  })

  vim.api.nvim_buf_set_keymap(Float.buf, "n", "p", "", {
    noremap = true,
    nowait = true,
    callback = function()
      SpecialPaste:head_off()
      vim.api.nvim_feedkeys(vim.v.count1 .. "p", "n", false)
    end
  })
end

function Float:create_win()
  self.win = create_float_win(self.buf)
end

function Float:close()
  pcall(vim.api.nvim_win_close, self.win, false)
  self.win = nil
end

function Extmark:del_extmark(mark)
  if not mark then return end
  vim.api.nvim_buf_del_extmark(Float.buf, Extmark.ns_id, mark.id)
  mark.id = nil
end

function Extmark:create_extmarks(lines)
  local regs = get_all_register()
  local pre

  for _, reg in ipairs(regs) do
    local sub_lines = vim.split(reg.content, "\n", { plain = true })
    for i = 1, #sub_lines do
      table.insert(lines, sub_lines[i])
    end

    local mark = {
      id = nil,
      row = #lines - #sub_lines,
      name = reg.name,
      _next = nil
    }

    if pre then
      pre._next = mark
    end

    table.insert(self.extmarks, mark)
    pre = mark
  end

  return lines
end

function Extmark:create_last_mark_next()
  self.extmarks[#self.extmarks]._next = { row = vim.api.nvim_buf_line_count(Float.buf) }
end

function Extmark:set_extmarks()
  self:create_last_mark_next()
  self:iter_extmarks(1, function(mark)
    self:set_extmark(mark, mark.row)
  end)
  self.extmarks[#self.extmarks].isLast = true
end

function Extmark:update_following_mark_row(i)
  self:iter_extmarks(i, function(mark)
    mark.row = vim.api.nvim_buf_get_extmark_by_id(Float.buf, self.ns_id, mark.id, {})[1]
  end)
  self:create_last_mark_next()
end

function Extmark:iter_extmarks(start, callback)
  local break_index;
  local break_mark;

  for i = start, #self.extmarks do
    local mark = self.extmarks[i]
    if callback(mark, i) then
      break_mark = mark
      break_index = i
      break
    end
  end
  return break_mark, break_index
end

function Extmark:get_reg_extmark_opt(mark)
  return {
    virt_lines = {
      {
        { mark.name .. " 寄存器：", "CursorLineNr" }
      },
    },
    virt_lines_above = true,
    right_gravity = false,
  }
end

function Extmark:set_extmark(mark, row)
  if not mark then return end
  mark.id = vim.api.nvim_buf_set_extmark(Float.buf, self.ns_id, row, 0, self:get_reg_extmark_opt(mark))
end

function BufAttch:stop()
  self.had_stop = true
end

function BufAttch:attach(opt)
  vim.api.nvim_buf_attach(Float.buf, false, {
    on_lines = function(_, buf, changedtick, firstline, lastline, new_lastline, byte_count)
      if self.had_stop then
        self.had_stop = nil
        return
      end

      if new_lastline < lastline then
        print("删除了 " .. lastline - new_lastline .. " 行")
        opt.on_del_line(lastline - new_lastline, firstline, lastline, new_lastline)
        return
      end

      if lastline < new_lastline then
        print("新增了 " .. new_lastline - lastline .. " 行")
        opt.on_add_line(new_lastline - lastline, firstline, lastline, new_lastline)
        return
      end
    end,
    on_detach = function() end
  })
end

local function update_registers()
  Extmark:iter_extmarks(1, function(mark)
    local lines = vim.api.nvim_buf_get_lines(Float.buf, mark.row, mark._next.row, false)
    local content = table.concat(lines, "\n")
    pcall(vim.fn.setreg, mark.name, content)
  end)
end

function OnAddLine:update(mark, break_index, add_count)
  vim.schedule(function()
    SpecialPaste:repair_extmark_location(mark, add_count)
    if not break_index then return end
    Extmark:update_following_mark_row(break_index)
    update_registers()
  end)
end

function OnDelLine:update(break_index, firsline, lastline)
  if self.type == "inner_ranger" then
    self:inner_ranger(break_index)
    return
  end
  if self.type == "outer_ranger" then
    self:outer_ranger(break_index, firsline, lastline)
    return
  end
  if self.type == "all_inner_ranger" then
    self:all_inner_ranger(break_index)
    return
  end
end

-- 基本思路：
--    1.找出完全被删除的寄存器 mark
--    2.在文本删除前删除这些寄存器
--    3.在文本删除后 set blank lines 保证每个寄存器至少有一行
--      由于 set blank lines 导致后边有一个寄存器 mark 上移了（right_gravity 的作用）
--      所以 这个 mark 也需要 更新 一下
--      所以 在 步骤1 中需要找出这个意外错误的寄存器 mark 并删除它
--    4.重新设置上述寄存器 mark
--    5.最后更新剩余的 mark 到结束
function OnDelLine:outer_ranger(break_index, firstline, lastline)
  local set_extmark_callbacks = {}
  local last_set_extmark_callback
  local lines = {}

  Extmark:iter_extmarks(break_index, function(mark)
    if firstline <= mark.row and lastline >= mark._next.row then
      Extmark:del_extmark(mark)
      table.insert(lines, "%%%%")
      table.insert(set_extmark_callbacks, function(row)
        Extmark:set_extmark(mark, row)
      end)
    elseif firstline <= mark.row and lastline < mark._next.row then
      Extmark:del_extmark(mark)
      last_set_extmark_callback = function(row)
        Extmark:set_extmark(mark, row)
      end
    end
  end)

  vim.schedule(function()
    if not break_index then return end

    if #set_extmark_callbacks > 0 then
      BufAttch:stop()
      vim.api.nvim_buf_set_lines(Float.buf, firstline, firstline, false, lines)
      for index, callback in ipairs(set_extmark_callbacks) do
        callback(firstline + index - 1)
      end
      if last_set_extmark_callback then
        last_set_extmark_callback(firstline + #set_extmark_callbacks)
      end
    end

    Extmark:update_following_mark_row(break_index)
    update_registers()
  end)
end

function OnDelLine:inner_ranger(break_index)
  vim.schedule(function()
    if not break_index then return end
    Extmark:update_following_mark_row(break_index)
    update_registers()
  end)
end

function OnDelLine:all_inner_ranger(break_index)
  local mark = Extmark.extmarks[break_index]
  local next_mark = Extmark.extmarks[break_index + 1]
  Extmark:del_extmark(mark)
  Extmark:del_extmark(next_mark)

  vim.schedule(function()
    BufAttch:stop()
    vim.api.nvim_buf_set_lines(Float.buf, mark.row, mark.row, false, { "%%%%" })
    Extmark:set_extmark(mark, mark.row)
    Extmark:set_extmark(next_mark, mark.row + 1)
    Extmark:update_following_mark_row(break_index)
    update_registers()
  end)
end

-- "inner_ranger" 删除的文本的范围 在完全在起始寄存器 mark 范围中
-- "outer_ranger" 删除的文本的范围 endline 超出起始寄存器 mark 范围
function OnDelLine:confirm_type(firstline, lastline, mark)
  if lastline <= mark._next.row then
    print("在 " .. mark.name .. " 寄存器中")
    self.type = "inner_ranger"

    -- if mark.isLast == true then
    --   if firstline == mark.row and lastline == mark._next.row - 1 then
    --     self.type = "all_inner_ranger"
    --   end
    -- else
    if firstline == mark.row and lastline == mark._next.row then
      self.type = "all_inner_ranger"
    end
    -- end
  elseif lastline > mark._next.row then
    self.type = "outer_ranger"
  end
end

local function on_add_line(add_count, firstline, lastline, new_lastline)
  local mark, break_index = Extmark:iter_extmarks(1, function(mark)
    if firstline >= mark.row and firstline < mark._next.row then
      print("在 " .. mark.name .. " 寄存器中")
      return true
    end
  end)
  OnAddLine:update(mark, break_index, add_count)
end

-- 一共 2 种情况：
--    1.在 mark 标记的范围内（中间）
--      1.开头
--      2.中间
--      3.结尾
--      特殊情况：mark 标记的范围只有一行，则删除后应该添加最小行 或 全部删除
--    2.firstline 在 mark 标记的范围内，endline 超出 mark 标记的范围
local function on_del_line(del_count, firstline, lastline, new_lastline)
  local mark, break_index = Extmark:iter_extmarks(1, function(mark)
    if firstline >= mark.row and firstline < mark._next.row then
      OnDelLine:confirm_type(firstline, lastline, mark)
      return true
    end
  end)
  OnDelLine:update(break_index, firstline, lastline)
end

function SpecialPaste:head_off()
  local row = unpack(vim.api.nvim_win_get_cursor(0))

  Extmark:iter_extmarks(1, function(_mark)
    if row == _mark.row then
      self.isPaste = true;
      return true
    end
  end)
end

function SpecialPaste:repair_extmark_location(mark, add_count)
  if not self.isPaste then return end
  Extmark:del_extmark(mark)
  Extmark:set_extmark(mark, mark.row + add_count)
  self.isPaste = nil
end

function M.open_register()
  if Float.win then
    Float:close()
    return
  end
  local lines = { "你好" }

  Float:create_buf()
  Float:create_win()
  Extmark:create_extmarks(lines)
  vim.api.nvim_buf_set_lines(Float.buf, 0, 1, false, lines)
  Extmark:set_extmarks()
  BufAttch:attach({ on_add_line = on_add_line, on_del_line = on_del_line })
end

local function create_command()
  vim.api.nvim_create_user_command("RegisterOpen", function()
    M.open_register()
  end, {})
end

function M.setup()
  create_command()
end

return M
