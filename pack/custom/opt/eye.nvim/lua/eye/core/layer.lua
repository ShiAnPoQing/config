local M = {}

--- @class Eye.Config.Layer.Highlight.RangeContext
--- @field topline integer
--- @field botline integer

--- @alias Eye.Config.Layer.Highlight.Range [integer, integer]|fun(ctx: Eye.Config.Layer.Highlight.RangeContext): [integer, integer]

--- @class Eye.Config.Layer.Highlight
--- @field range Eye.Config.Layer.Highlight.Range
--- @field group? string

--- @class Eye.Config.Layer
--- @field enable? boolean
--- @field highlight? Eye.Config.Layer.Highlight[]

local function hl(data)
  vim.api.nvim_buf_set_extmark(0, data.ns_id, data.start_row, 0, {
    end_row = data.end_row,
    hl_group = data.group,
    hl_eol = true,
  })
end

local function get_win(buf)
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local win
  for _, v in ipairs(wins) do
    if vim.api.nvim_win_get_buf(v) == buf then
      win = v
      break
    end
  end
  return win
end

--- @param range Eye.Config.Layer.Highlight.Range
local function get_range(range, wininfo)
  if type(range) == "function" then
    return range({
      topline = wininfo.topline,
      botline = wininfo.botline,
    })
  elseif type(range) == "table" then
    return range
  end
  return { wininfo.topline, wininfo.botline }
end

--- @param buf integer
--- @param config Eye._Config._Layer
function M.draw(buf, config)
  local win = get_win(buf)
  if not win then
    return
  end
  local wininfo = vim.fn.getwininfo(win)[1]

  for _, value in ipairs(config.highlight) do
    local group = value.group
    local range = get_range(value.range, wininfo)
    hl({
      start_row = range[1],
      end_row = range[2],
      group = group or "EyeLayer",
      ns_id = require("eye.core").ns_id,
      buf = buf,
    })
  end
end

return M
