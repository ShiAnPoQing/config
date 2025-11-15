local M = {}
local util = require("neo-symbol.util")

--- @param filter fun(item: any): boolean
function M:symbol_to_qf(filter)
  util.request_symbol(function(result_map)
    if #result_map == 0 then
      return
    end
    local result = result_map[1]
    --- @type vim.quickfix.entry[]
    local symbols = vim.lsp.util.symbols_to_items(result.result, 0)

    local list = {}
    for _, item in ipairs(symbols) do
      ---@diagnostic disable-next-line: undefined-field
      if filter(item) then
        table.insert(list, item)
      end
    end
    vim.fn.setqflist(list)
  end)
end

function M:function_symbol_to_qf()
  self:symbol_to_qf(function(item)
    return item.kind == "Function"
  end)
end

function M:method_symbol_to_qf()
  self:symbol_to_qf(function(item)
    return item.kind == "Method"
  end)
end

function M:class_symbol_to_qf()
  self:symbol_to_qf(function(item)
    return item.kind == "Class"
  end)
end

return M
