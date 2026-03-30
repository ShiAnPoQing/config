--- @class Eye.Plugin.Line
local M = {}

--- @class Eye.Plugin.Line.RangeContext
--- @field topline integer
--- @field botline integer

--- @class Eye.Plugin.Line.Config
--- @field matched fun(ctx: Eye.RootGroup.Config.Hook.Context)
--- @field range? fun(range: Eye.Plugin.Line.RangeContext): [integer, integer]

--- @type Eye.Plugin.Line.Config
local default_config = {
  matched = function() end,
  range = function(range)
    return { range.topline, range.botline }
  end,
}

local function iter(cursor_row, topline, botline, callback)
  local top_break
  local bot_break
  local count = 0

  while true do
    count = count + 1
    if bot_break and top_break then
      break
    end

    if cursor_row - count >= topline then
      callback(cursor_row - count)
    else
      top_break = true
    end

    if cursor_row + count <= botline then
      callback(cursor_row + count)
    else
      bot_break = true
    end
  end
end

--- @param config Eye.Plugin.Line.Config
function M.gaze(config)
  config = vim.tbl_deep_extend("force", default_config, config)
  local win = vim.api.nvim_get_current_win()
  local wininfo = vim.fn.getwininfo(win)[1]
  local cursor = vim.api.nvim_win_get_cursor(win)
  local virt_col = vim.fn.virtcol(".")

  local range = config.range({
    topline = wininfo.topline,
    botline = wininfo.botline,
  })

  --- @type Eye.LabelSpec[]
  local labels = {
    buf = vim.api.nvim_get_current_buf(),
  }
  iter(cursor[1], range[1], range[2], function(row)
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    ---@diagnostic disable-next-line: param-type-mismatch
    local _col = vim.fn.virtcol2col(win, row, virt_col) - 1
    if _col < 0 then
      _col = 0
    end
    local col = virt_col - 1
    if vim.fn.strdisplaywidth(line) < virt_col then
      col = vim.fn.strdisplaywidth(line) - 1
    end
    col = col - wininfo.leftcol
    if col < 0 then
      col = -1
    end
    labels[#labels + 1] = {
      items = { { row = row - 1, col = col } },
      data = {
        row = row,
        col = _col,
      },
    }
  end)
  require("eye")
    .gaze({
      labels,
      label = {
        extmark = {
          virt = true,
        },
        matched = config.matched,
      },
      layer = {
        {
          range = function()
            return { range[1] - 1, range[2] }
          end,
        },
      },
    })
    :start()
end

return M
