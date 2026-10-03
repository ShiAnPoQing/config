--- @class my.insert.VISUAL_BLOCK
local M = {}
local VISUAL_BLOCK = ""
local multicursor_active

function M.__first()
  if multicursor_active then
    multicursor_active = nil
    return
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local top = math.min(start_pos[2], end_pos[2])
  local bottom = math.max(start_pos[2], end_pos[2])
  local left = math.min(start_pos[3], end_pos[3])

  for i = top, bottom do
    if i == bottom then
      pcall(vim.api.nvim_win_set_cursor, 0, { i, left - 1 })
    else
      pcall(vim.api.nvim_buf_set_extmark, 0, my.multicursor.ns, i - 1, left - 1, {})
    end
  end

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
    vim.cmd("normal! " .. VISUAL_BLOCK)
  end
end

--- This function is not Atom.
--- It will produece a series of atoms for repeat.
function M.first()
  if not my.multicursor.active() then
    --- This is will work when multicursor is not active.
    --- For repeat, it only works when multicursor is not active.
    --- For repeat, if multicursor is active, it will not work.
    vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_BLOCK.__handle_visual_exit()<cr>"), "nt", false)
    vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_BLOCK.__first()<cr>"), "nt", false)
    vim.api.nvim_feedkeys(vim.v.count1 .. "i", "nt", false)
  else
    --- This is will work when multicursor is active.
    --- For repeat, it only works when multicursor is active.
    --- For repeat, if multicursor is not active, it will not work.
    vim.api.nvim_feedkeys(vim.v.count1 .. "I", "nt", false)
  end
end

function M.__last()
  if multicursor_active then
    multicursor_active = nil
    return
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local top = math.min(start_pos[2], end_pos[2])
  local bottom = math.max(start_pos[2], end_pos[2])
  local right = math.max(start_pos[3], end_pos[3])

  for i = top, bottom do
    if i == bottom then
      vim.api.nvim_win_set_cursor(0, { i, right - 1 })
    else
      vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, right - 1, {})
    end
  end

  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if ev.data.type == "insert" then
        my.multicursor.clear(0)
        return true
      end
    end,
  })
end

function M.last()
  if not my.multicursor.active() then
    --- This is will work when multicursor is not active.
    --- For repeat, it only works when multicursor is not active.
    --- For repeat, if multicursor is active, it will not work.
    vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_BLOCK.__handle_visual_exit()<cr>"), "nt", false)
    vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.insert.VISUAL_BLOCK.__last()<cr>"), "nt", false)
    vim.api.nvim_feedkeys(vim.v.count1 .. "a", "n", false)
  else
    --- This is will work when multicursor is active.
    --- For repeat, it only works when multicursor is active.
    --- For repeat, if multicursor is not active, it will not work.
    vim.api.nvim_feedkeys(vim.v.count1 .. "A", "nt", false)
  end
end

function M.first_non_blank()
  M.first()
end

function M.last_non_blank()
  M.last()
end

return M
