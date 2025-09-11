local M = {}

--- @class CodeActionOptions

--- @param options? CodeActionOptions
function M.setup(options) end

function M.show()
  M.request_code_action({
    bufnr = vim.api.nvim_get_current_buf(),
    callback = function(results)
      -- print(vim.inspect(results))
      -- vim.print(results[1].result[1])
      -- vim.print(results)
    end,
  })
end

--- @class RequestCodeActionOptions
--- @field bufnr number
--- @field callback function

--- @param options RequestCodeActionOptions
function M.request_code_action(options)
  local params = vim.lsp.util.make_range_params(0, "utf-8")
  params.context = { diagnostics = vim.diagnostic.get(options.bufnr) }
  vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(results, a, c)
    -- vim.print(results)
    vim.print(c)
    options.callback(results)
  end)
end

function M.code_action() end
local function test() end

return M
