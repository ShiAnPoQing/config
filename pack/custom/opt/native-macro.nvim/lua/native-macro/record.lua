--- @class NativeMacro._Record
--- @field records table<string, vim.event.cmdatom.data[]>
local M = {
  records = {},
}

-- {0-9a-z".=*+}
--- @param reg string
function M.start(reg)
  local atoms = {}
  M.records[tostring(reg)] = atoms
  vim.api.nvim_create_autocmd("CmdAtom", {
    group = vim.api.nvim_create_augroup("native-macro", { clear = true }),
    callback = function(ev)
      local data = ev.data --[[@as vim.event.cmdatom.data]]
      if vim.fn.getcmdwintype() == "" then
        atoms[#atoms + 1] = data
      end
    end,
  })
end

function M.stop(reg)
  local atoms = M.records[tostring(reg)] or {}
  if atoms[1] and atoms[1].cmd == "q" then
    table.remove(atoms, 1)
  end
  pcall(vim.api.nvim_clear_autocmds, { group = "native-macro" })
end

function M.init()
  local reg
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      reg = vim.fn.reg_recording()
      M.start(reg)
    end,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      M.stop(reg)
      vim.print(M.records)
    end,
  })
end

return M
