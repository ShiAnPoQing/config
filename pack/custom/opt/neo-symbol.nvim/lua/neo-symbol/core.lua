local M = {}
local Window = require("neo-symbol.window")
local util = require("neo-symbol.util")

function M.symbol()
  util.request_symbol(function(result_map)
    if #result_map == 0 then
      return
    end
    Window:create({
      position = "right",
    })
    for _, item in ipairs(result_map[1].result) do
      local kind = vim.lsp.protocol.SymbolKind[item.kind]
      local range = item.range
      local text = vim.api.nvim_buf_get_text(
        0,
        range.start.line,
        range.start.character,
        range["end"].line,
        range["end"].character,
        {}
      )[1]
      vim.print(kind .. " " .. item.name .. " " .. text)
    end
  end)
end

return M
