--- @class NativeDir.Preview.Image:NativeDir.Preview
local M = {}

--- @class NativeDir.Preview.Image.Opts

local function read_u32_be(data, i)
  local a, b, c, d = data:byte(i, i + 3)
  return ((a * 256 + b) * 256 + c) * 256 + d
end

local function png_size(data)
  if data:sub(1, 8) ~= "\137PNG\r\n\26\n" then
    return
  end

  local width = read_u32_be(data, 17)
  local height = read_u32_be(data, 21)

  return width, height
end

local function get_image_ratio(file)
  local data = vim.fn.readblob(file, 0, 24)
  data = vim.fn.blob2list(data)

  local function u32be(i)
    return ((data[i] * 256 + data[i + 1]) * 256 + data[i + 2]) * 256 + data[i + 3]
  end

  local width = u32be(17)
  local height = u32be(21)

  return width / height
end

--- @param file string
--- @param opts NativeDir.Preview.Image.Opts
function M.open(file, opts)
  opts = opts or {}
  local ratio = get_image_ratio(file)
  local vim_width = vim.o.columns
  local vim_height = vim.o.lines
  local width = math.floor(0.5 * vim_width)
  local height = math.floor((width / ratio) / 2)

  local col = math.floor((vim_width - width) / 2)
  local row = math.floor((vim_height - height) / 2)
  M.id = vim.ui.img.set(vim.fn.readblob(file), {
    row = row,
    col = col,
    width = width,
    zindex = 50,
  })
end

function M.close()
  if M.id and vim.ui.img.get(M.id) then
    vim.ui.img.del(M.id)
    M.id = nil
  end
end

function M.is_open()
  return M.id ~= nil and vim.ui.img.get(M.id) ~= nil
end

return M
