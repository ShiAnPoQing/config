-- 寄存器：register-functions
--   getreg() 获取寄存器的内容
--   getreginfo() 获取寄存器的信息
--   getregtype() 获取寄存器的类型
--   setreg() 设置寄存器的内容和类型
--   reg_executing() 返回正在执行的寄存器名称
--   reg_recording() 返回正在记录的寄存器名称

local M = {}
local RegMark = {
  ns_id = vim.api.nvim_create_namespace("register-control"),
  extmarks = {},
  win = nil,
  buf = nil
}

local function get_all_register()
  local registers = {
    -- '"', -- 未命名寄存器
    -- '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',                -- 数字寄存器
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    -- 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', -- 命名寄存器
    -- '-',      -- 小删除寄存器
    -- '*', '+', -- 系统剪贴板寄存器
    -- '/',      -- 搜索寄存器
    -- ':',      -- 命令行寄存器
    -- '%', '#', -- 当前和上一个文件名
    -- '='       -- 表达式寄存器
  }

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

local function create_float_win()
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

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "[Registers]")
  vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
  local win = vim.api.nvim_open_win(buf, true, opts)

  local augroup = vim.api.nvim_create_augroup('RegisterBuffer' .. buf, { clear = true })
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    group = augroup,
    callback = function()
      print("xing")
    end
  })
  require("utils.float.win-move").load(buf, {})

  return {
    buf = buf,
    win = win
  }
end

function RegMark:update_mark_info(count, _i)
  for i = _i, #self.extmarks do
    local mark = self.extmarks[i]
    mark.firstline = mark.firstline - count
    mark.lastline = mark.lastline - count
  end
end

local function buf_attach(buf, on_lines)
  local had_stop;
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, bufnr, changedtick, firstline, lastline, new_lastline, byte_count)
      if had_stop then
        had_stop = nil
        return
      end

      on_lines({
        buf = bufnr,
        firstline = firstline,
        lastline = lastline,
        new_lastline = new_lastline,
        stop = function()
          had_stop = true
        end
      })
    end,
    on_detach = function() end
  })
end

function RegMark:set_extmarks()
  for _, mark in ipairs(self.extmarks) do
    self:set_extmark(mark)
  end
end

function RegMark:set_extmark(mark)
  if mark.id then
    vim.api.nvim_buf_del_extmark(self.buf, self.ns_id, mark.id)
  end

  mark.id = vim.api.nvim_buf_set_extmark(self.buf, self.ns_id, mark.firstline, 0, {
    virt_lines = {
      {
        { mark.name .. " 寄存器：", "CursorLineNr" }
      },
    },
    virt_lines_above = true
  })
end

function RegMark:create_reg_extmarks(lines)
  local regs = get_all_register()
  for _, reg in pairs(regs) do
    local sub_lines = vim.split(reg.content, "\n", { plain = true })

    for i = 1, #sub_lines do
      table.insert(lines, sub_lines[i])
    end

    table.insert(self.extmarks, {
      firstline = #lines - #sub_lines,
      lastline = #lines,
      col = 0,
      name = reg.name
    })
  end
end

function M.open_register()
  if RegMark.win then
    pcall(vim.api.nvim_win_close, RegMark.win, false)
    RegMark.win = nil
    return
  end

  local float = create_float_win()
  RegMark.buf = float.buf
  RegMark.win = float.win

  local lines = { "你好" }
  RegMark:create_reg_extmarks(lines)
  vim.api.nvim_buf_set_lines(RegMark.buf, 0, 1, false, lines)
  RegMark:set_extmarks()
  buf_attach(RegMark.buf, function(opt)
    local new_lastline = opt.new_lastline
    local lastline = opt.lastline
    local firstline = opt.firstline

    if new_lastline < lastline then
      local count = lastline - new_lastline
      print("删除了 " .. count .. " 行")

      local next_index;
      for index, mark in ipairs(RegMark.extmarks) do
        local mark_firstline = mark.firstline
        local mark_lastline = mark.lastline

        if lastline > mark_firstline and lastline <= mark_lastline then
          print("在" .. mark.name .. "中")
          if count == mark.lastline - mark.firstline then
            vim.schedule(function()
              opt.stop()
              vim.api.nvim_buf_set_lines(RegMark.buf, mark.firstline, mark.firstline, false, { "不可删除" })
              RegMark:set_extmark(mark)
              vim.api.nvim_win_set_cursor(RegMark.win, { mark.firstline + 1, 0 })
            end)
          end
          mark.lastline = mark.lastline - count
          next_index = index + 1
          break
        end
      end
      RegMark:update_mark_info(-count, next_index)
      -- print(vim.inspect(extmarks))
      return
    end

    if lastline < new_lastline then
      local count = new_lastline - lastline
      print("新增了 " .. count .. " 行")

      local next_index;
      for index, mark in ipairs(RegMark.extmarks) do
        local mark_firstline = mark.firstline
        local mark_lastline = mark.lastline

        if firstline > mark_firstline and firstline <= mark_lastline then
          print("在" .. mark.name .. "中")
          mark.lastline = mark.lastline + count
          next_index = index + 1
          break
        end
      end
      RegMark:update_mark_info(count, next_index)
      return
    end
  end)
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


-- vim.api.nvim_buf_attach(buf, false, {
--   on_lines = function(_, bufnr, changedtick, firstline, lastline, new_lastline, old_lastline)
--     print("---------------")
--     print("firstline:", firstline)
--     print("lastline:", lastline)
--     print("new_lastline:", new_lastline)
--     print("old_lastline:", old_lastline)
--     print("---------------")
--   end,
--   -- 如果返回 true，将分离监听器
--   on_detach = function()
--   end,
-- })
-- for i = 1, #extmarks do
--   local mark = extmarks[i]
--   vim.schedule(function()
--     local lines = vim.api.nvim_buf_get_lines(float.buf, mark.firstline, mark.lastline, false)
--     local content = table.concat(lines, "\n")
--     print(mark.name .. "中应为：", content)
--     print("--------------")
--     pcall(vim.fn.setreg, mark.name, content)
--   end)
-- end
