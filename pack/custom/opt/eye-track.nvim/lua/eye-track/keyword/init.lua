local M = {}

M.main = function(opts)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local rightcol = leftcol + wininfo.width - wininfo.textoff
  local keyword = opts.keyword
  local registers = require("eye-track.keyword.core"):main({
    topline = topline,
    botline = botline,
    leftcol = leftcol,
    rightcol = rightcol,
    keyword = keyword,
  })
  require("eye-track.core").main(registers)
end

return M
