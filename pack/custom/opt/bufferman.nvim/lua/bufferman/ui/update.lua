local M = {}
M.__index = M

--- @class Bufferman.UI.Update.Event
--- @field removed fun()
--- @field added fun()

--- @param buf integer
function M:new(buf)
  local o = setmetatable({}, self)
  o.cache = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  o.buf = buf
  return o
end

--- @param event Bufferman.UI.Update.Event
function M:attach(event)
  vim.api.nvim_buf_attach(self.buf, false, {
    on_bytes = function(
      _,
      buf,
      _,
      start_row,
      start_col,
      start_byte,
      old_end_row,
      old_end_col,
      old_end_byte,
      new_end_row,
      new_end_col,
      new_end_byte
    )
      local removed_line = old_end_row - start_row
      local added_line = new_end_row - start_row

      if not (removed_line > 0 or added_line > 0) then
      end
    end,
    -- on_lines = function(_, buf, _, first, last, new_last, _)
    --   local removed = last - first
    --   local added = new_last - first
    --
    --   if removed > 0 then
    --     -- event.removed()
    --     return
    --   end
    --
    --   if added > 0 then
    --     self.cache = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    --     local added_lines = vim.api.nvim_buf_get_lines(buf, first, new_last, false)
    --     print("added:", added)
    --     vim.print(added_lines)
    --     -- event.added()
    --     return
    --   end
    --   print("range:", first, last, "->", new_last)
    --   print("removed:", removed)
    -- end,
  })
end

return M
