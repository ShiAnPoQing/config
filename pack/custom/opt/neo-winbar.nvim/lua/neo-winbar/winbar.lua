local M = {}

local NeoWinbarSymbols = "NeoWinbarSymbols"
local NeoWinbarFile = "NeoWinbarFile"
local NeoWinbarFileIcon = "NeoWinbarFileIcon"

local function get_winbar_file()
  local filename = vim.fn.expand("%:t")
  local file_type = vim.fn.expand("%:e")
  local value = ""
  local file_icon = ""

  if filename and filename ~= "" then
    local default = false

    if not file_type or file_type == "" then
      file_type = ""
      default = true
    end

    file_icon = require("nvim-web-devicons").get_icon(filename, file_type, { default = default })
    value = value .. " %#" .. "DevIcon" .. file_type .. "#" .. file_icon .. "%*"
    value = value .. " %#" .. NeoWinbarFile .. "#" .. filename .. "%*"
  end

  return value
end

local function get_winbar_navic()
  local navic = require("nvim-navic")
  local ok, location = pcall(navic.get_location, { highlight = true })
  local value = ""

  if ok and navic.is_available() and location and location ~= "" then
    value = value .. "%#NavicSeparator# > %*" .. location
  end

  return value
end

function M.show()
  local value = ""
  local context = get_winbar_navic():gsub(
    "(%*%%#(NavicIcons%w+)#)(.-)(%%*%%#)NavicText#",
    function(full, icon, middle, prefix)
      return full .. middle .. prefix .. icon .. "#"
    end
  )
  value = get_winbar_file() .. context

  local ok = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not ok then
    return
  end
end

function M.attach(client, bufnr)
  require("nvim-navic").attach(client, bufnr)
  vim.api.nvim_create_autocmd({
    "DirChanged",
    "CursorMoved",
    "BufWinEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
  }, {
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.lua" },
    callback = function()
      require("neo-winbar.winbar").show()
    end,
  })
end

return M
