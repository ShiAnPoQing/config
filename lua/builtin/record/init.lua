local M = {}

local ns_id = vim.api.nvim_create_namespace("record")

function M.record()
  local reg_name = vim.fn.reg_recording()
  vim.on_key(function(_, typed) end, ns_id)
end

function M.recorded()
  vim.on_key(nil, ns_id)
end

vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    M.record()
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    M.recorded()
  end,
})

return M
