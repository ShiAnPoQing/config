--- @class NativeMacro._Record
--- @field records table<string, vim.event.cmdatom.data[]>
local M = {
  records = {},
  ns_id = vim.api.nvim_create_namespace("native-macro"),
}

-- {0-9a-z".=*+}
function M.start()
  local reg_name = vim.fn.reg_recording()
  local atoms = {}
  M.records[tostring(reg_name)] = atoms

  local group = vim.api.nvim_create_augroup("native-macro", { clear = true })
  vim.api.nvim_create_autocmd("CmdAtom", {
    group = group,
    callback = function(ev)
      atoms[#atoms + 1] = ev.data --[[@as vim.event.cmdatom.data]]
    end,
  })
end

function M.stop()
  vim.on_key(nil, M.ns_id)
  pcall(vim.api.nvim_clear_autocmds, { group = "native-macro" })
end

function M.init()
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      M.start()
    end,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      M.stop()
    end,
  })
end

return M
