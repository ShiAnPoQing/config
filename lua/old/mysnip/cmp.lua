local luasnip = require("luasnip")

local source = {}

function source.complete(_, _, callback)
  local bufnr = vim.api.nvim_get_current_buf()
  if not luasnip.cache[bufnr] then
    local completion_items = vim.tbl_map(function(s)
      ---@type lsp.CompletionItem
      local item = {
        word = s.trigger,
        label = s.trigger,
        kind = vim.lsp.protocol.CompletionItemKind.Snippet,
        insertText = s.body,
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
      }
      return item
    end, luasnip.get_buf_snips())

    luasnip.cache[bufnr] = completion_items
  end
  callback(luasnip.cache[bufnr])
end

return source
