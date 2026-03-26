local M = {}

local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

---@type NuiPopup
local popup
local show

function M.init(lines)
  popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "Neovim Doc Diff",
        top_align = "center",
      },
    },
    position = "50%",
    relative = "editor",
    size = {
      width = "80%",
      height = "60%",
    },
  })
  popup:on({ event.BufHidden }, function()
    show = false
    popup:unmount()
  end)
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, {
    buf = popup.bufnr,
  })
  vim.api.nvim_set_option_value("filetype", "diff", {
    buf = popup.bufnr,
  })
end

function M.show(lines)
  if not show then
    show = true
    M.init(lines)
    popup:mount()
  else
    show = false
    popup:unmount()
  end
end

return M
