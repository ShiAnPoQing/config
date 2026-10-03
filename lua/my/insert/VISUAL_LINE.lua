--- @class my.insert.VISUAL_LINE
local M = {}
local VISUAL_LINE = "V"
local multicursor_active

local function clear_multicursor_on_leave_insert()
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if ev.data.type == "insert" then
        my.multicursor.clear(0)
        return true
      end
    end,
  })
end

function M.__handle_visual_exit()
  if my.multicursor.active() then
    multicursor_active = true
  else
    vim.cmd("normal! " .. VISUAL_LINE)
  end
end

function M.__first()
  if multicursor_active then
    multicursor_active = nil
    return
  end
  local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
  for i = start_row, end_row do
    if i == end_row then
      vim.api.nvim_win_set_cursor(0, { i, 0 })
    else
      vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, 0, {})
    end
  end
  clear_multicursor_on_leave_insert()
end

function M.__last()
  if multicursor_active then
    multicursor_active = nil
    return
  end
  local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
  for i = start_row, end_row do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
    if i == end_row then
      vim.api.nvim_win_set_cursor(0, { i, #line })
    else
      vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, #line, {})
    end
  end
  clear_multicursor_on_leave_insert()
end

function M.__last_non_blank()
  if multicursor_active then
    multicursor_active = nil
    return
  end
  local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
  for i = start_row, end_row do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
    local col = line:reverse():find("%S") or 0
    col = #line - col + 1
    if i == end_row then
      vim.api.nvim_win_set_cursor(0, { i, col - 1 })
    else
      vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, col - 1, {})
    end
  end
  clear_multicursor_on_leave_insert()
end

function M.__first_non_blank()
  if multicursor_active then
    multicursor_active = nil
    return
  end
  local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
  for i = start_row, end_row do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
    local col = line:find("%S") or 1
    col = col - 1
    if i == end_row then
      vim.api.nvim_win_set_cursor(0, { i, col })
    else
      vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, col, {})
    end
  end
  clear_multicursor_on_leave_insert()
end

function M.first_non_blank()
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__handle_visual_exit()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__first_non_blank()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.v.count1 .. "i", "n", false)
end

function M.last_non_blank()
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__handle_visual_exit()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__last_non_blank()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.v.count1 .. "a", "n", false)
end

function M.first()
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__handle_visual_exit()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__first()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.v.count1 .. "i", "n", false)
end

function M.last()
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__handle_visual_exit()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_LINE.__last()<cr>"), "nt", false)
  vim.api.nvim_feedkeys(vim.v.count1 .. "a", "n", false)
end

return M
