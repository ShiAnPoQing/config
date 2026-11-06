--- @class my.edit
local M = {}

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
--- @field count? integer default 1
--- @field above? boolean default false

--- @param opts? my.edit.add_blank_line.Opts
function M.add_blank_line(opts)
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  vim.validate("opts.count", opts.count, "number", true)
  vim.validate("opts.follow", opts.follow, "boolean", true)
  vim.validate("opts.above", opts.above, "boolean", true)
  if vim.v.cascading then
    return
  end
  local count = math.max(opts.count or 1, 1)
  local follow = opts.follow
  local above = opts.above
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
  M.add_blank_line({
    count = vim.v.count1,
    follow = false,
    above = false,
  })
end

function M.below_add_blank_line_follow()
  M.add_blank_line({
    count = vim.v.count1,
    follow = true,
    above = false,
  })
end

function M.above_add_blank_line()
  M.add_blank_line({
    count = vim.v.count1,
    follow = false,
    above = true,
  })
end

function M.above_add_blank_line_follow()
  M.add_blank_line({
    count = vim.v.count1,
    follow = true,
    above = true,
  })
end

function M.above_below_add_blank_line()
  M.above_add_blank_line_follow()
  M.below_add_blank_line_follow()
end

return M
