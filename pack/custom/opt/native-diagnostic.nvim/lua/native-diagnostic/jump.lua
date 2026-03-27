local M = {}

--- @param diagnostic? vim.Diagnostic
--- @param bufnr integer
function M.float(diagnostic, bufnr)
  if not diagnostic then
    return
  end
  vim.schedule(function()
    vim.diagnostic.open_float({ namespace = diagnostic.namespace, bufnr = bufnr })
  end)
end

--- @param diagnostic? vim.Diagnostic
--- @param bufnr integer
function M.virtual_text(diagnostic, bufnr)
  vim.diagnostic.show(
    diagnostic.namespace,
    bufnr,
    { diagnostic },
    { virtual_lines = false, virtual_text = { current_line = true } }
  )
end

--- @param diagnostic? vim.Diagnostic
--- @param bufnr integer
function M.virtual_line(diagnostic, bufnr)
  vim.diagnostic.show(
    diagnostic.namespace,
    bufnr,
    { diagnostic },
    { virtual_lines = { current_line = true }, virtual_text = false }
  )
end

--- @param diagnostic? vim.Diagnostic
--- @param bufnr integer
function M.alternate(diagnostic, bufnr)
  local style = require("native-diagnostic.style").style
  if style.on_alternate_jump then
    style.on_alternate_jump(diagnostic, bufnr)
    return
  end
  if style.config.virtual_lines or style.config.virtual_text then
    M.float(diagnostic, bufnr)
    return
  end
  -- ...
  if not style.config.virtual_lines and not style.config.virtual_text then
    M.float(diagnostic, bufnr)
    return
  end
end

return M
