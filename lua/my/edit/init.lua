--- @class my.edit
local M = {}

--- @param lnum integer
--- @param count integer
--- @param dir -1|1
local function add_blank_line(lnum, count, dir)
  local offset = dir < 0 and 1 or 0
  local repeated = vim.fn["repeat"]({ "" }, count)
  vim.api.nvim_buf_set_lines(0, lnum - offset, lnum - offset, true, repeated)
end

--- @class my.edit.add_blank_line.Opts
--- @field follow? boolean
--- @field indent? boolean

--- @param dir -1|1
--- @param opts my.edit.add_blank_line.Opts
function M.add_blank_line(dir, count, opts)
  vim.validate("dir", dir, "number")
  vim.validate("count", count, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  count = math.max(count, 1)
  local mode = vim.api.nvim_get_mode().mode
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1]
  add_blank_line(lnum, count, dir)
  if opts.follow then
    return
  end
  vim.api.nvim_win_set_cursor(0, { lnum + (dir < 0 and 0 or count), cursor[2] })
  if mode == "i" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(opts.indent and "<C-f><C-g>u" or "", true, false, true),
      "n",
      true
    )
  end
end

--- @param dir -1|1
--- @param opts my.edit.add_blank_line.Opts
function M._add_blank_line(dir, count, opts)
  vim.validate("dir", dir, "number")
  vim.validate("count", count, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  count = math.max(count, 1)
  local mode = vim.api.nvim_get_mode().mode
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1]
  add_blank_line(lnum, count, dir)
  if opts.follow then
    return
  end
  vim.api.nvim_win_set_cursor(0, { lnum + (dir < 0 and 0 or count), cursor[2] })
  if mode == "i" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(opts.indent and "<C-f><C-g>u" or "", true, false, true),
      "n",
      true
    )
  end
end

--- neovim multicursor cascade 不合理, 真心不好用
local cascade_count

function M.above_add_blank_line_cursor_follow()
  if not vim.v.cascading then
    cascade_count = vim.v.count1
  end
  vim.o.follow = true
  M.add_blank_line(-1, cascade_count, {
    follow = true,
    indent = true,
  })
  vim.o.follow = false
end

return M
