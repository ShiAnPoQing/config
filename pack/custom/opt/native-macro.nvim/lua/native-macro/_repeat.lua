---@class NativeMacro._Repeat
local M = {
  last_register_name = nil,
  pendings = {},
}

local Record = require("native-macro._record")

function M:_repeat(register_name)
  if register_name == "@" then
    register_name = self.last_register_name
  else
    self.last_register_name = register_name
  end
  local datas = Record.records[register_name]

  for _, data in ipairs(datas) do
    data = data --[[@as vim.event.cmdatom.data]]
    if data.type == "excmd" then
      vim.api.nvim_feedkeys("", "nx", false)
      vim.api.nvim_command(data.text)
    else
      if data.lhs then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(data.lhs, true, false, true), "m", false)
      end
    end
  end
end

function M.init()
  vim.api.nvim_create_autocmd("User", {
    pattern = "Macro",
    callback = function(ev) end,
  })
end

return M
