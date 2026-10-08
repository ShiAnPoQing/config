--- @class my.env.promax.insert
--- @field NORMAL my.env.promax.insert.NORMAL
--- @field n my.env.promax.insert.NORMAL
local M = my.util.defer_require(..., {
  NORMAL = true,
  ["n"] = "NORMAL",
})

function M._fix_stop_insert_cursor_position()
  local col = vim.fn.col(".")
  if col == 1 then
    vim.cmd("normal! " .. vim.keycode("<Ignore>"))
    return
  end
  vim.cmd("normal! l")
end

function M.stopinsert()
  vim.api.nvim_feedkeys(vim.keycode("<esc><Cmd>lua my[0].insert._fix_stop_insert_cursor_position()<cr>"), "n", false)
end

return M
