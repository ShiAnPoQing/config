local M = {}
-- 寄存器：register-functions
--   getreg() 获取寄存器的内容
--   getreginfo() 获取寄存器的信息
--   getregtype() 获取寄存器的类型
--   setreg() 设置寄存器的内容和类型
--   reg_executing() 返回正在执行的寄存器名称
--   reg_recording() 返回正在记录的寄存器名称

local Extmark = {
  extmarks = {},
  ns_id = vim.api.nvim_create_namespace("register-control"),
}

local Float = {
  buf = nil,
  win = nil
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

  return lines
end

function Extmark:set_extmark(mark, buf)
  if mark.id then
    vim.api.nvim_buf_del_extmark(buf, self.ns_id, mark.id)
  end

  mark.id = vim.api.nvim_buf_set_extmark(buf, self.ns_id, mark.firstline, 0, {
    virt_lines = {
      {
        { mark.name .. " 寄存器：", "CursorLineNr" }
      },
    },
    virt_lines_above = true
  })
end

function Extmark:set_extmarks(buf)
  for _, mark in ipairs(self.extmarks) do
    self:set_extmark(mark, buf)
  end
end

function Extmark:update_extmarks(count, _i)
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

function M.open_register()
  if Float.win then
    Float:close()
    return
  end
  Float:create_buf()
  Float:create_win()
  local lines = { "nihao" }
  Extmark:create_extmarks(lines)
  vim.api.nvim_buf_set_lines(Float.buf, 0, 1, false, lines)
  Extmark:set_extmarks(Float.buf)
  buf_attach(Float.buf, function(opt)
    local new_lastline = opt.new_lastline
    local lastline = opt.lastline
    local firstline = opt.firstline

    if new_lastline < lastline then
      local del_count = lastline - new_lastline
      print("删除了 " .. del_count .. " 行")

      local next_index;
      for index, mark in ipairs(Extmark.extmarks) do
        local mark_firstline = mark.firstline
        local mark_lastline = mark.lastline

        if lastline > mark_firstline and lastline <= mark_lastline then
          print("在" .. mark.name .. "中")
          if del_count == mark.lastline - mark.firstline then
            vim.schedule(function()
              opt.stop()
              vim.api.nvim_buf_set_lines(Float.buf, mark.firstline, mark.firstline, false, { "不可删除" })
              Extmark:set_extmark(mark, Float.buf)
              vim.api.nvim_win_set_cursor(Float.win, { mark.firstline + 1, 0 })
            end)
          end
          mark.lastline = mark.lastline - del_count
          next_index = index + 1
          break
        end
      end
      Extmark:update_extmarks(-del_count, next_index)
      return
    end

    if lastline < new_lastline then
      local add_count = new_lastline - lastline
      print("新增了 " .. add_count .. " 行")

      local next_index;
      for index, mark in ipairs(Extmark.extmarks) do
        local mark_firstline = mark.firstline
        local mark_lastline = mark.lastline

        if firstline > mark_firstline and firstline <= mark_lastline then
          print("在" .. mark.name .. "中")
          mark.lastline = mark.lastline + add_count
          next_index = index + 1
          break
        end
      end
      Extmark:update_extmarks(add_count, next_index)
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
