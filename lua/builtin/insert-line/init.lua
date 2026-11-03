local M = {}

--- @param lnum integer
--- @param count integer
--- @param above boolean
local function add_blank_line(lnum, count, above)
  local offset = above and 1 or 0
  local repeated = vim.fn["repeat"]({ "" }, count)
  vim.api.nvim_buf_set_lines(0, lnum - offset, lnum - offset, true, repeated)
end

local function insert_line(above, follow, indent)
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1]
  add_blank_line(lnum, count, above)
  if follow then
    return
  end
  vim.api.nvim_win_set_cursor(0, { lnum + (above and 0 or count), cursor[2] })
  if mode == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(indent and "<C-f><C-g>u" or "", true, false, true), "n", true)
  end
end

function M.above()
  insert_line(true, true, true)
  vim.schedule(function()
    require("repeat").set_operation(M.above)
  end)
end

function M.above_no_follow()
  insert_line(true, false, true)
end

function M.above_no_follow_no_indent()
  insert_line(true, false, false)
  vim.schedule(function()
    require("repeat").set_operation(M.above_no_follow_no_indent)
  end)
end

function M.below()
  insert_line(false, true, true)
  vim.schedule(function()
    require("repeat").set_operation(M.below)
  end)
end

function M.below_no_follow()
  insert_line(false, false, true)
  vim.schedule(function()
    require("repeat").set_operation(M.below)
  end)
end

function M.below_no_follow_no_indent()
  insert_line(false, false, false)
  vim.schedule(function()
    require("repeat").set_operation(M.below_no_follow_no_indent)
  end)
end

function M.above_and_below()
  insert_line(false, true, true)
  vim.schedule(function()
    require("repeat").set_operation(M.above_and_below)
  end)
end

return M
