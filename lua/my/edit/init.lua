--- @class my.edit
--- @field NORMAL my.edit.NORMAL
--- @field ['n'] my.edit.NORMAL
--- @field COMMAND my.edit.COMMAND
--- @field ['c'] my.edit.COMMAND
--- @field INSERT my.edit.INSERT
--- @field ['i'] my.edit.INSERT
local M = my.util.defer_require("my.edit", {
  NORMAL = ..., --- @module 'my.edit.NORMAL'
  ["n"] = "NORMAL",
  COMMAND = ..., --- @module 'my.edit.COMMAND'
  ["c"] = "COMMAND",
  INSERT = ..., --- @module 'my.edit.INSERT'
  ["i"] = "INSERT",
})

--- neovim multicursor cascade 不合理, 真心不好用

local function set_cursor(cursor, offset)
  if cursor[1] ~= -1 then
    vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, cursor[2] + offset, cursor[3], { id = cursor[1] })
  else
    vim.api.nvim_win_set_cursor(0, { cursor[2] + 1 + offset, cursor[3] })
  end
end

--- @class my.edit.add_blank_line.Opts
--- @field follow? boolean default false

--- @param count integer
--- @param opts? my.edit.add_blank_line.Opts
function M.add_blank_line(count, opts)
  vim.validate("count", count, "number")
  vim.validate("opts", opts, "table", true)
  count = math.floor(count)
  if count == 0 then
    return
  end
  opts = opts or {}
  vim.validate("opts.follow", opts.follow, "boolean", true)
  if vim.v.cascading then
    return
  end
  local follow = opts.follow
  local above = count < 0
  count = math.abs(count)
  local multicursors = my.multicursor.get(0, 0, -1)
  local cursor = vim.api.nvim_win_get_cursor(0)
  table.insert(multicursors, { -1, cursor[1] - 1, cursor[2] })
  -- stylua: ignore
  table.sort(multicursors, function(a, b) return a[2] > b[2] end)
  local offset = above and -1 or 0
  for _, cs in ipairs(multicursors) do
    local start = cs[2] + 1
    local end_ = start
    local blank_lines = vim.fn["repeat"]({ "" }, count)
    cs[3] = follow and cs[3] or 0
    vim.api.nvim_buf_set_lines(0, start + offset, end_ + offset, false, blank_lines)
  end
  for i, cs in ipairs(multicursors) do
    if above then
      if follow then
        set_cursor(cs, (#multicursors - i + 1) * count)
      else
        set_cursor(cs, (#multicursors - i) * count)
      end
    else
      if follow then
        set_cursor(cs, (#multicursors - i) * count)
      else
        set_cursor(cs, (#multicursors - i + 1) * count)
      end
    end
  end
end

function M.below_add_blank_line()
  M.add_blank_line(vim.v.count1, { follow = false })
end

function M.below_add_blank_line_follow()
  M.add_blank_line(vim.v.count1, { follow = true })
end

function M.above_add_blank_line()
  M.add_blank_line(-vim.v.count1, { follow = false })
end

function M.above_add_blank_line_follow()
  M.add_blank_line(-vim.v.count1, { follow = true })
end

function M.above_below_add_blank_line()
  M.above_add_blank_line_follow()
  M.below_add_blank_line_follow()
end

return M
