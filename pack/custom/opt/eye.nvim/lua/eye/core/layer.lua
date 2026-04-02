--- @class Eye.Layer
--- @field config Eye.Layer.Config
--- @field layers Eye.Layer.Spec[]
local M = {
  config = {
    enable = true,
    hl_group = "EyeLayer",
  },
}
M.__index = M

--- @class Eye.Layer.Config.Highlight.RangeContext
--- @field topline integer
--- @field botline integer

--- @alias Eye.Layer.Config.Highlight.Range [integer, integer]|fun(ctx: Eye.Layer.Config.Highlight.RangeContext): [integer, integer]

--- @class Eye.Layer.Spec
--- @field buf integer
--- @field range Eye.Layer.Config.Highlight.Range
--- @field hl_group? string

--- @class Eye.Layer.Config
--- @field enable? boolean
--- @field hl_group? string

local function hl(data)
  vim.api.nvim_buf_set_extmark(data.buf, data.ns_id, data.start_row, 0, {
    end_row = data.end_row,
    hl_group = data.hl_group,
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

--- @param range Eye.Layer.Config.Highlight.Range
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

function M:draw()
  if not self.config.enable then
    return
  end
  for _, spec in ipairs(self.layers) do
    local win = get_win(spec.buf)
    if win then
      local wininfo
      local range = spec.range
      if type(spec.range) == "function" then
        if not wininfo then
          wininfo = vim.fn.getwininfo(win)[1]
        end
        range = get_range(spec.range, wininfo)
      end
      local hl_group = spec.hl_group or self.config.hl_group
      hl({
        start_row = range[1],
        end_row = range[2],
        hl_group = hl_group,
        ns_id = require("eye.core.tree.root").get_ns_id(),
        buf = spec.buf,
      })
    end
  end
end

--- @param layers Eye.Layer.Spec[]|fun(): Eye.Layer.Spec[]
--- @param config Eye.Layer.Config
function M:new(layers, config)
  layers = type(layers) == "function" and layers() or layers or {}
  local o = setmetatable({}, self) --[[@as Eye.Layer]]
  o.config = config or {}
  o.layers = layers --[[@as Eye.Layer.Spec[]]
  return o
end

return M
