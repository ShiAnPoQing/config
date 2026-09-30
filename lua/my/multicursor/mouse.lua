--- @class my.multicursor.mouse
local M = {}

local target_win
local path

--- @return vim.api.keyset.get_extmark_item|nil
local function get_mouse_cursor(mousepos)
  return my.multicursor.get(0, { mousepos.line - 1, mousepos.column - 1 }, { mousepos.line - 1, mousepos.column - 1 })[1]
end

--- reset path
--- mouse cursor is not rollback cursor
--- 则删除 mouse cursor,，也表明历史断了，所以重置历史
--- @param cursor vim.api.keyset.get_extmark_item
local function reset_path(cursor)
  my.multicursor.del(0, cursor[1])
  path = {}
end

--- advance path
--- 创建光标，更新历史，新光标成为 head
local function advance_path(mousepos)
  local ok = pcall(my.multicursor.set, 0, mousepos.line - 1, mousepos.column - 1)
  if not ok then
    return
  end
  local cursor = get_mouse_cursor(mousepos)
  if cursor then
    table.insert(path, cursor[1])
  end
end

--- rollback path
--- mouse 位置光标是 head 的前一个
local function rollback_path(mousepos)
  my.multicursor.del(0, path[#path])
  table.remove(path, #path)
  --- rollback cursor 需要成为最新 head，
  --- 这里选择删除它(即使它本来就存在)，
  --- 后续 advance_path 会再次创建它，并成为最新 head
  table.remove(path, #path)
  advance_path(mousepos)
end

--- @param cursor vim.api.keyset.get_extmark_item|nil
local function should_reset_path(cursor)
  return cursor and cursor[1] ~= path[#path - 1]
end

--- @param cursor vim.api.keyset.get_extmark_item|nil
local function should_rollback_path(cursor)
  return cursor and cursor[1] == path[#path - 1]
end

function M.click()
  local mousepos = vim.fn.getmousepos()
  target_win = mousepos.winid
  --- Avoid using the native `<C-LeftMouse>`,
  --- as exiting Insert mode causes the multicursor to lose track,
  --- resulting in a misalignment between the primary and secondary cursors.
  local cursor = get_mouse_cursor(mousepos)
  if cursor then
    my.multicursor.del(0, cursor[1])
  else
    my.multicursor.set(0, mousepos.line - 1, mousepos.column - 1)
    path = { get_mouse_cursor(mousepos)[1] }
  end
end

function M.drag()
  local mousepos = vim.fn.getmousepos()
  if mousepos.winid ~= target_win then
    return
  end
  local cursor = get_mouse_cursor(mousepos)
  if should_reset_path(cursor) then
    reset_path(cursor --[[@as vim.api.keyset.get_extmark_item]])
    return
  end
  if should_rollback_path(cursor) then
    rollback_path(mousepos)
    return
  end
  advance_path(mousepos)
end

function M.release()
  local mode = vim.api.nvim_get_mode().mode
  path = {}
  if mode == "i" then
    local insert_keys = "<esc>a"
    --- Re-enter Insert mode and activate cascading.
    if vim.fn.col(".") == 1 then
      insert_keys = "<esc>i"
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(insert_keys, true, false, true), "nt", false)
  end
end

return M
