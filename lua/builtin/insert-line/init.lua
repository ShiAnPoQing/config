local M = {}

local function add_blank_line(count, above)
  local offset = above and 1 or 0
  local repeated = vim.fn["repeat"]({ "" }, count)
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, linenr - offset, linenr - offset, true, repeated)
end

local function insert_line(above, follow, indent)
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  add_blank_line(count, above)
  if follow then
    return
  end
  local key = count .. (above and "k" or "j")

  if mode == "i" then
    local indent_key = vim.api.nvim_replace_termcodes(indent and "<C-f><C-g>u" or "", true, false, true)
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    key = esc .. key .. "A" .. indent_key
  end

  vim.api.nvim_feedkeys(key, "n", true)
  return key
end

function M.above()
  insert_line(true, true, true)
  vim.schedule(function()
    require("repeat").set_operation(M.above)
  end)
end

function M.above_no_follow()
  insert_line(true, false, true)
  vim.schedule(function()
    require("repeat").set_operation(M.above_no_follow)
  end)
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

return M
