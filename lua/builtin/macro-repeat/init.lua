local M = {}

function M.macro_repeat()
  local core = require("builtin.macro-repeat.core")
  local char = vim.fn.nr2char(vim.fn.getchar())
  char = char == "@" and core.last_register_name or char
  core.macro_repeat(char)
end

return M
