local M = {}

local current_record
local current_changedtick = vim.b.changedtick
M.is_repeat_lead_to_cursored = false

function M.vim_repeat()
  if not current_record then
    return
  end
  M.is_repeat_lead_to_cursored = true
  current_record.callback()
end

--- @class RecordOptions
--- @field callback fun()
--- @field name string

--- @param opts RecordOptions
function M.record(opts)
  current_record = opts
  vim.keymap.set("n", ".", function()
    M.vim_repeat()
  end, { noremap = true })
end

--- @class RepeatOptions

--- @param opts RepeatOptions
function M.setup(opts)
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("custom-repeat", {}),
    callback = function()
      local changedtick = vim.b.changedtick
      if changedtick ~= current_changedtick then
        current_changedtick = changedtick
        if not M.is_repeat_lead_to_cursored then
          vim.keymap.set("n", ".", ".", { noremap = true })
        else
          M.is_repeat_lead_to_cursored = false
        end
      end
    end,
  })
end

return M
