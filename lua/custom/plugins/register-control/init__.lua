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
  if not self.buf then
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
  end
end

function Float:create_win()
  self.win = create_float_win(self.buf)
end

function Float:close()
  pcall(vim.api.nvim_win_close, self.win, false)
  self.win = nil
end

function Extmark:create_extmarks(lines)
  local regs = get_all_register()
  local pre;

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

function Extmark:set_extmark(mark, buf)
  if mark.id then
    vim.api.nvim_buf_del_extmark(buf, self.ns_id, mark.id)
  end

  mark.id = vim.api.nvim_buf_set_extmark(buf, self.ns_id, mark.row, 0, {
    virt_lines = {
      {
        { mark.name .. " 寄存器：", "CursorLineNr" }
      },
    },
    virt_lines_above = true,
    right_gravity = false,
  })
end

function Extmark:set_extmarks(buf)
  self.extmarks[#self.extmarks]._next = { row = vim.api.nvim_buf_line_count(buf) + 1 }
  for i = 1, #registers do
    local mark = self.extmarks[i]
    self:set_extmark(mark, buf)
  end
end

function Extmark:update_extmarks(buf, _i)
  for i = _i, #self.extmarks do
    local mark = self.extmarks[i]
    local pos = vim.api.nvim_buf_get_extmark_by_id(buf, self.ns_id, mark.id, {})
    mark.row = pos[1]
  end
  self.extmarks[#self.extmarks]._next = { row = vim.api.nvim_buf_line_count(buf) + 1 }
end

function Extmark:iter_extmarks(callback)
  local break_index;
  local break_mark;
  for i = 1, #registers do
    local mark = self.extmarks[i]
    local should_break = callback(mark)
    if should_break then
      break_mark = mark
      break_index = i
      break
    end
  end
  return break_mark, break_index
end

function BufAttch:stop()
  self.had_stop = true
end

function BufAttch:special_p()
  self.is_special_p = true
end

local function update_registers()
  for i = 1, #Extmark.extmarks do
    local mark = Extmark.extmarks[i]
    local lines = vim.api.nvim_buf_get_lines(Float.buf, mark.row, mark._next.row, false)
    local content = table.concat(lines, "\n")
    -- print(mark.name .. "中应为：", content)
    -- print("--------------")
    -- pcall(vim.fn.setreg, mark.name, content)
  end
end

function BufAttch:attach(buf, opt)
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, bufnr, changedtick, firstline, lastline, new_lastline, byte_count)
      if self.had_stop then
        self.had_stop = nil
        return
      end

      if new_lastline < lastline then
        print("删除了 " .. lastline - new_lastline .. " 行")
        opt.on_del_line(bufnr, lastline - new_lastline, firstline, lastline, new_lastline)
        return
      end

      if lastline < new_lastline then
        print("新增了 " .. new_lastline - lastline .. " 行")
        opt.on_add_line(bufnr, new_lastline - lastline, firstline, lastline, new_lastline)
        return
      end
    end,
    on_detach = function() end
  })
end

local function on_add_line(bufnr, add_count, firstline, lastline, new_lastline)
  local mark, break_index = Extmark:iter_extmarks(function(mark)
    if firstline >= mark.row and firstline < mark._next.row then
      print("在 " .. mark.name .. " 寄存器中")
      return true
    end
  end)


  vim.schedule(function()
    if BufAttch.is_special_p then
      print(mark.name)
      vim.api.nvim_buf_del_extmark(bufnr, Extmark.ns_id, mark.id)
      mark.id = vim.api.nvim_buf_set_extmark(bufnr, Extmark.ns_id, mark.row + add_count, 0, {
        virt_lines = {
          {
            { mark.name .. " 寄存器：", "CursorLineNr" }
          },
        },
        virt_lines_above = true,
        right_gravity = false,
      })
      BufAttch.is_special_p = false
    end

    if not break_index then return end
    Extmark:update_extmarks(bufnr, break_index)
    update_registers()
  end)
end

local function on_del_line(bufnr, del_count, firstline, lastline, new_lastline)
  local del_last;

  local mark, break_index = Extmark:iter_extmarks(function(mark)
    if firstline >= mark.row and firstline < mark._next.row then
      if lastline <= mark._next.row then
        print("在 " .. mark.name .. " 寄存器中")
      elseif lastline > mark._next.row then
        del_last = true
      end
      return true
    end
  end)

  local mark_resets = {}
  local last_mark_reset;
  local _lines = {}

  if del_last then
    for i = break_index, #Extmark.extmarks do
      local mark = Extmark.extmarks[i]

      if firstline <= mark.row and lastline >= mark._next.row then
        vim.api.nvim_buf_del_extmark(Float.buf, Extmark.ns_id, mark.id)
        mark.id = nil
        table.insert(_lines, "不可删除")
        table.insert(mark_resets, function(row)
          mark.id = vim.api.nvim_buf_set_extmark(Float.buf, Extmark.ns_id, row, 0, {
            virt_lines = {
              {
                { mark.name .. " 寄存器：", "CursorLineNr" }
              },
            },
            virt_lines_above = true,
            right_gravity = false,
          })
        end)
      elseif firstline <= mark.row and lastline < mark._next.row then
        vim.api.nvim_buf_del_extmark(Float.buf, Extmark.ns_id, mark.id)
        mark.id = nil
        last_mark_reset = function(row)
          mark.id = vim.api.nvim_buf_set_extmark(Float.buf, Extmark.ns_id, row, 0, {
            virt_lines = {
              {
                { mark.name .. " 寄存器：", "CursorLineNr" }
              },
            },
            virt_lines_above = true,
            right_gravity = false,
          })
        end
      end
    end
  end

  vim.schedule(function()
    if not break_index then return end
    if #mark_resets > 0 then
      print("count:", #mark_resets)
      BufAttch:stop()
      vim.api.nvim_buf_set_lines(bufnr, firstline, firstline, false, _lines)
      for index, callback in ipairs(mark_resets) do
        callback(firstline + index - 1)
      end
      last_mark_reset(firstline + #mark_resets)
    end
    Extmark:update_extmarks(bufnr, break_index)
    update_registers()
  end)
end

local function is_special_p()
  local row = unpack(vim.api.nvim_win_get_cursor(0))
  local special;
  for i = 1, #Extmark.extmarks do
    local mark = Extmark.extmarks[i]
    if row == mark.row then
      special = true;
      break
    end
  end
  return special
end

function M.open_register()
  if Float.win then
    Float:close()
    return
  end
  local lines = { "nihao" }

  Float:create_buf()
  Float:create_win()
  Extmark:create_extmarks(lines)
  vim.api.nvim_buf_set_lines(Float.buf, 0, 1, false, lines)
  Extmark:set_extmarks(Float.buf)
  BufAttch:attach(Float.buf, { on_add_line = on_add_line, on_del_line = on_del_line })


  vim.api.nvim_buf_set_keymap(Float.buf, "n", "p", "", {
    noremap = true,
    nowait = true,
    callback = function()
      if is_special_p() then
        BufAttch:special_p()
      end
      vim.api.nvim_feedkeys(vim.v.count1 .. "p", "n", false)
    end
  })
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
