-- 寄存器：register-functions
--   getreg() 获取寄存器的内容
--   getreginfo() 获取寄存器的信息
--   getregtype() 获取寄存器的类型
--   setreg() 设置寄存器的内容和类型
--   reg_executing() 返回正在执行的寄存器名称
--   reg_recording() 返回正在记录的寄存器名称

local M = {}

local border = {
  -- 左上角
  "╭",
  -- 上边框
  "─",
  -- 右上角
  "╮",
  -- 右边框
  "│",
  -- 右下角
  "╯",
  -- 下边框
  "─",
  -- 左下角
  "╰",
  -- 左边框
  "│"
}

local function get_all_register()
  -- 定义要检查的寄存器列表
  local registers = {
    '"',                                                             -- 未命名寄存器
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',                -- 数字寄存器
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', -- 命名寄存器
    '-',                                                             -- 小删除寄存器
    '*', '+',                                                        -- 系统剪贴板寄存器
    '/',                                                             -- 搜索寄存器
    ':',                                                             -- 命令行寄存器
    '%', '#',                                                        -- 当前和上一个文件名
    '='                                                              -- 表达式寄存器
  }

  local results = {}
  for _, reg in ipairs(registers) do
    local content = vim.fn.getreg(reg)
    if content ~= '' then
      table.insert(results, {
        name = reg,
        content = content
      })
    end
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
    border = border,
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "[Registers]")
  vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
  local win = vim.api.nvim_open_win(buf, true, opts)

  local changed_lines = {}

  -- 附加到缓冲区以跟踪更改
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, bufnr, changedtick, firstline, lastline, new_lastline, old_lastline)
      print("---------------")
      print("firstline:", firstline)
      print("lastline:", lastline)
      print("new_lastline:", new_lastline)
      print("old_lastline:", old_lastline)
      print("---------------")
    end,
    -- 如果返回 true，将分离监听器
    on_detach = function()
    end,
  })
  local augroup = vim.api.nvim_create_augroup('RegisterBuffer' .. buf, { clear = true })

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    group = augroup,
    callback = function()
      -- print(vim.inspect(changed_lines))
    end
  })

  return {
    buf = buf,
    win = win
  }
end

local function create_command()
  vim.api.nvim_create_user_command("RegisterOpen", function()
    M.open_register()
  end, {})
end

function M.setup()
  create_command()
end

function M.open_register()
  local regs = get_all_register()
  local float = create_float_win()
  local lines = { "你好" }
  local extmarks = {}

  for _, reg in pairs(regs) do
    local sub_lines = vim.split(reg.content, "\n", { plain = true })
    if #sub_lines > 1 then
      for i = 1, #sub_lines do
        table.insert(lines, sub_lines[i])
      end
    else
      table.insert(lines, sub_lines[1])
    end

    extmarks[reg.name] = {
      line = #lines,
      col = 0
    }
  end
  vim.api.nvim_buf_set_lines(float.buf, 0, 1, false, lines)
  local ns_id = vim.api.nvim_create_namespace("register-control")

  for key, value in pairs(extmarks) do
    vim.api.nvim_buf_set_extmark(float.buf, ns_id, value.line - 1, 0, {
      virt_lines = {
        {
          { key .. " 寄存器", "CursorLineNr" }
        },
      },
      virt_lines_above = true
    })
  end
end

return M
