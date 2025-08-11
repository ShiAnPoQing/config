local M = {}

local current_record

function M.vim_repeat()
  if not current_record then
    return
  end
  current_record.callback()
end

--- @class RecordOptions
--- @field callback fun()
--- @field name string

--- @param opts RecordOptions
function M.record(opts)
  current_record = opts
end

function M.reset()
  current_record = nil
end

--- @class RepeatOptions

--- @param opts RepeatOptions
function M.setup(opts)
  vim.keymap.set({ "n", "i" }, "<M-.>", function()
    M.vim_repeat()
  end, { noremap = true })
end

return M
