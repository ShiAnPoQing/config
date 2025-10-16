local M = {}

local WIN_ID

local function get_max_width(lines)
  local max_width = 10
  for _, value in ipairs(lines) do
    max_width = math.max(max_width, #value)
  end
  return max_width
end

local function get_file_size()
  local size = vim.fn.getfsize(vim.fn.expand("%:p"))
  local size_with_unit = ""
  if size < 1024 then
    size_with_unit = size .. " B"
  else
    size = size / 1024
    if size < 1024 then
      size_with_unit = string.format("%.2f", size) .. " KB"
    else
      size = size / 1024
      if size < 1024 then
        size_with_unit = string.format("%.2f", size) .. " MB"
      else
        size = size / 1024
        size_with_unit = string.format("%.2f", size) .. " GB"
      end
    end
  end

  return size_with_unit
end

function M.file_details()
  if WIN_ID then
    pcall(vim.api.nvim_win_close, WIN_ID, false)
    WIN_ID = nil
    return
  end

  local lines = {}

  local file_name = vim.fn.expand("%:t")
  local file_path = vim.fn.expand("%:p")
  local file_ext = vim.fn.expand("%:e")
  local file_size = get_file_size()
  local file_created = ""
  local file_modified = ""
  local stat = vim.loop.fs_stat(file_path)
  if stat then
    file_created = vim.fn.strftime("%Y-%m-%d %H:%M:%S", stat.birthtime.nsec)
    file_modified = vim.fn.strftime("%Y-%m-%d %H:%M:%S", stat.birthtime.sec)
  end
  local line_count = vim.api.nvim_buf_line_count(0)
  table.insert(lines, "      Name: " .. file_name .. " ")
  table.insert(lines, "      Path: " .. file_path .. " ")
  table.insert(lines, "      Type: " .. file_ext .. " ")
  table.insert(lines, "      Size: " .. file_size .. " ")
  table.insert(lines, "   Created: " .. file_created .. " ")
  table.insert(lines, "  Modified: " .. file_modified .. " ")
  table.insert(lines, " LineCount: " .. line_count .. " lines ")
  table.insert(lines, "")
  table.insert(lines, " Press <Esc> or q to close ")

  local width = get_max_width(lines)
  local parent_width = vim.api.nvim_win_get_width(0)
  local parent_height = vim.api.nvim_win_get_height(0)

  local row = math.ceil((parent_height - 2) / 2)
  local col = math.ceil((parent_width - width) / 2)

  local opts = {
    relative = "editor",
    width = width,
    row = row,
    col = col,
    height = #lines,
    anchor = "NW",
    title = { { " File Details ", "Normal" } },
    title_pos = "center",
    style = "minimal",
    border = {
      { "┌", "Normal" },
      { "─", "Normal" },
      { "┐", "Normal" },
      { "│", "Normal" },
      { "┘", "Normal" },
      { "─", "Normal" },
      { "└", "Normal" },
      { "│", "Normal" },
    },
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, lines)

  WIN_ID = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_set_option_value("modifiable", false, {
    buf = buf,
  })
  require("utils.float.win-move").load(buf, {
    on_close = function()
      pcall(vim.api.nvim_win_close, WIN_ID, false)
      WIN_ID = nil
    end,
  })
end

function M.setup(opt)
  vim.api.nvim_create_user_command("FileDetails", function()
    M.file_details()
  end, {})
end

return M

-- 系统函数和文件操作：system-functions file-functions
--   glob() 扩展通配符
--   globpath() 在多个目录中扩展通配符
--   glob2regpat() 将glob模式转换为搜索模式
--   findfile() 在目录列表中查找文件
--   finddir() 在目录列表中查找目录
--   resolve() 查找快捷方式指向的位置
--   fnamemodify() 修改文件名
--   pathshorten() 缩短路径中的目录名
--   simplify() 简化路径而不改变其含义
--   executable() 检查可执行程序是否存在
--   exepath() 可执行程序的完整路径
--   filereadable() 检查文件是否可读
--   filewritable() 检查文件是否可写
--   getfperm() 获取文件的权限
--   setfperm() 设置文件的权限
--   getftype() 获取文件的类型
--   isabsolutepath() 检查路径是否为绝对路径
--   isdirectory() 检查目录是否存在
--   getfsize() 获取文件的大小
--   getcwd() 获取当前工作目录
--   haslocaldir() 检查当前窗口是否使用|:lcd|或|:tcd|
--   tempname() 获取临时文件名
--   mkdir() 创建新目录
--   chdir() 更改当前工作目录
--   delete() 删除文件
--   rename() 重命名文件
--   system() 获取shell命令的结果作为字符串
--   systemlist() 获取shell命令的结果作为列表
--   environ() 获取所有环境变量
--   getenv() 获取一个环境变量
--   setenv() 设置环境变量
--   hostname() 系统名称
--   readfile() 将文件读入行列表
--   readblob() 将文件读入Blob
--   readdir() 获取目录中的文件名列表
--   writefile() 将行列表或Blob写入文件
--   filecopy() 将文件从{from}复制到{to}
-- 日期和时间：date-functions time-functions
--   getftime() 获取文件的最后修改时间
--   localtime() 获取当前时间（秒）
--   strftime() 将时间转换为字符串
--   strptime() 将日期/时间字符串转换为时间
--   reltime() 准确获取当前或经过的时间
--   reltimestr() 将reltime()结果转换为字符串
--   reltimefloat() 将reltime()结果转换为浮点数
