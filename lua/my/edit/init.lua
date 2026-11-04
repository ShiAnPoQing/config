--- @class my.edit
local M = {}

--- @class my.edit.add_blank_line.Opts
--- @field follow? boolean
--- @field indent? boolean
--- @field count? integer

--- neovim multicursor cascade 不合理, 真心不好用
--- @param dir -1|1
--- @param opts? my.edit.add_blank_line.Opts
function M.add_blank_line(dir, opts)
  vim.validate("dir", dir, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  vim.validate("opts.count", opts.count, "number", true)
  vim.validate("opts.follow", opts.follow, "boolean", true)
  vim.validate("opts.indent", opts.indent, "boolean", true)
  if vim.v.cascading then
    return
  end
  local count = math.max(1, opts.count or 1)
  local follow = opts.follow
  local indent = opts.indent
  local multicursors = my.multicursor.get(0, 0, -1)
  local cursor = vim.api.nvim_win_get_cursor(0)
  table.insert(multicursors, { -1, cursor[1] - 1, cursor[2] })
  table.sort(multicursors, function(a, b)
    return a[2] > b[2]
  end)
  local offset = dir < 0 and -1 or 0
  for _, cs in ipairs(multicursors) do
    local lnum = cs[2] + 1
    local repeated = vim.fn["repeat"]({ "" }, count)
    vim.api.nvim_buf_set_lines(0, lnum + offset, lnum + offset, true, repeated)
  end
  multicursors = my.multicursor.get(0, 0, -1)
  cursor = vim.api.nvim_win_get_cursor(0)
  table.insert(multicursors, { -1, cursor[1] - 1, cursor[2] })
  if follow then
    return
  end
  local cursor_offset = dir < 0 and -count or count
  for _, cs in ipairs(multicursors) do
    if cs[1] == -1 then
      vim.api.nvim_win_set_cursor(0, { cs[2] + 1 + cursor_offset, 0 })
    else
      vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, cs[2] + cursor_offset, 0, { id = cs[1] })
    end
  end
  local mode = vim.api.nvim_get_mode().mode
  if mode == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(indent and "<C-f><C-g>u" or "", true, false, true), "n", true)
  end
end

function M.above_add_blank_line_cursor_follow()
  M.add_blank_line(-1, {
    count = vim.v.count1,
    follow = true,
    indent = true,
  })
end

function M.above_add_blank_line_cursor_not_follow()
  M.add_blank_line(-1, {
    count = vim.v.count1,
    follow = false,
    indent = true,
  })
end

function M.below_add_blank_line_cursor_follow()
  M.add_blank_line(1, {
    count = vim.v.count1,
    follow = true,
    indent = true,
  })
end

function M.below_add_blank_line_cursor_not_follow()
  M.add_blank_line(1, {
    count = vim.v.count1,
    follow = false,
    indent = true,
  })
end

return M
