local M = {}

local Key = require("magic.key")
local Line_hl = require("magic.line-hl")

--- @class MagicScreenOpts
--- @field position "left" | "right" | "top" | "bottom"
--- @field callback fun(opts)

local function iter_line(cursor_row, topline, botline, callback)
  local top_break
  local bot_break
  local count = 0

  while true do
    count = count + 1
    if top_break and bot_break then
      break
    end

    if cursor_row - count >= topline then
      callback(cursor_row - count)
    else
      top_break = true
    end

    if cursor_row + count - 1 <= botline then
      callback(cursor_row + count - 1)
    else
      bot_break = true
    end
  end
end

--- @param opts MagicScreenOpts
local function get_virt_col(opts, wininfo)
  local virt_col
  if opts.position == "left" then
    virt_col = 0
  elseif opts.position == "right" then
    virt_col = wininfo.width - wininfo.textoff - 1
  end

  return virt_col
end

--- @param opts MagicScreenOpts
function M.magic_screen(opts)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  local key = Key:init()
  Line_hl:init(topline, botline)
  key.compute(botline - topline + 1)

  iter_line(cursor_row, topline, botline, function(line)
    local col = get_virt_col(opts, wininfo)
    local _col = col
    if opts.position == "right" then
      _col = col - 1
    end
    key.register({
      callback = function()
        opts.callback({
          line = line,
        })
      end,
      one_key = {
        line = line - 1,
        virt_col = col,
      },
      two_key = {
        line = line - 1,
        virt_col = _col,
      },
    })
  end)

  key.on_key({
    unmatched_callback = function()
      Line_hl:del_hl()
    end,
    matched_callback = function()
      Line_hl:del_hl()
    end,
  })
end

return M
