local M = {}

function M.get_icon(name)
  if name == "directory" then
    return "", "Directory"
  end
  local icon, icon_hl = require("nvim-web-devicons").get_icon_by_filetype(name)
  if not icon then
    icon, icon_hl = require("nvim-web-devicons").get_icon(name)
  end
  if type(icon) == "string" then
    return icon, icon_hl
  end
  return "", "Normal"
end

function M.size(size)
  local units = { "B", "KB", "MB", "GB", "TB" }
  local i = 1
  if size == nil then
    return "0 " .. units[i]
  end

  while size >= 1024 and i < #units do
    size = size / 1024
    i = i + 1
  end

  if size % 1 == 0 then
    return string.format("%.0f %s", size, units[i])
  end

  return string.format("%.2f %s", size, units[i])
end

function M.feedkey(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", true)
end

return M
