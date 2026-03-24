local M = {}
local Window = require("neovim-doc-cn.window")

function M.diff()
  vim.ui.input({
    prompt = "Neovim DOC Diff: ",
  }, function(input)
    local result = require("neovim-doc-cn.diff").diff(input or "") --[[@as string]]
    if result then
      Window.show(vim.fn.split(result, "\n"))
    end
  end)
end

return M
