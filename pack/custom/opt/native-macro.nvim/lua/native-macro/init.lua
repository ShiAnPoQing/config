local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      require("native-macro.record"):start()
    end,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      require("native-macro.record"):stop()
    end,
  })
end
function M._repeat()
  ---@diagnostic disable-next-line: param-type-mismatch
  local char = vim.fn.nr2char(vim.fn.getchar())
  require("native-macro.repeat"):_repeat(char)
end

return M
