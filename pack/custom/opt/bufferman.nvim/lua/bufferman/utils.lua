local M = {}

function M.is_buflisted(buf)
  return M.is_buf_valid(buf) and vim.api.nvim_get_option_value("buflisted", {
    buf = buf,
  })
end

function M.is_buf_valid(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

function M.is_win_valid(win)
  return win and vim.api.nvim_win_is_valid(win)
end

function M.try(fn, ...)
  if type(fn) == "function" then
    return fn(...)
  end
end

return M
