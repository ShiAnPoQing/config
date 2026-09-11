local M = {}

function M.setup()
  require("native-macro._record").init()
  require("native-macro._repeat").init()
end

-- {0-9a-z".=*+}
function M._repeat()
  ---@diagnostic disable-next-line: param-type-mismatch
  local char = vim.fn.nr2char(vim.fn.getchar())
  require("native-macro._repeat"):_repeat(char)
end

function M.user() end

return M
