local M = {}

function M.request_symbol(callback)
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
  }
  vim.lsp.buf_request_all(0, "textDocument/documentSymbol", params, callback)
end

return M
