--- @class (private) my.repeat._capture
local M = {}
local id
local capturing
local capture
local patchs = {}
local history = {}
local last_capture

function M.get_history()
  return history
end

function M.get_last_capture()
  return last_capture
end

function M.set_last_capture(c)
  last_capture = c
end

--- @param callback fun(atom: vim.event.cmdatom.data): vim.event.cmdatom.data|nil
function M.patch(callback)
  table.insert(patchs, callback)
end

function M.start()
  capturing = true
  capture = {}
end

function M.finish()
  capturing = nil
  table.insert(history, capture)
  last_capture = capture
  capture = nil
end

local function apply_patch(data)
  for _, patch in ipairs(patchs) do
    local new_data = patch(data)
    if type(new_data) == "table" then
      data = vim.tbl_deep_extend("force", data, new_data)
    end
  end
  return data
end

function M.active()
  id = vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      local data = ev.data --[[@as vim.event.cmdatom.data]]
      data.buf = ev.buf
      if capturing and data.lhs ~= "." then
        table.insert(capture, data)
        return
      end
      local is_redo_or_undo = data.changed and (data.undoseq or 0) <= (vim.b[ev.buf].maxseq or 0)
      vim.b[ev.buf].maxseq = math.max(vim.b[ev.buf].maxseq or 0, data.undoseq or 0)
      if data.changed and not is_redo_or_undo and data.lhs ~= "." then
        data = apply_patch(data)
        M.start()
        capture = { data }
        M.finish()
      end
    end,
  })
end

function M.deactive()
  vim.api.nvim_del_autocmd(id)
  id = nil
end

return M
