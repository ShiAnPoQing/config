--- @class Eye.Word
local M = {}

--- @class Eye.Word.RegexContext
--- @field word.inner string
--- @field word.outer string
--- @field WORD.inner string
--- @field WORD.outer string

--- @class Eye.Word.Config
--- @field matched fun(ctx: Eye.Config.Hook.Context)
--- @field regex string|fun(ctx: Eye.Word.RegexContext): string
--- @field position -1 | 1

local function iter(win, matches, topline, botline, callback)
  local cursor_row = vim.api.nvim_win_get_cursor(win)[1]
  local count = 0
  local up_break = nil
  local down_break = nil
  while true do
    if up_break and down_break then
      break
    end

    if cursor_row - count >= topline then
      local match = matches[cursor_row - count - topline + 1]
      for _, value in ipairs(match) do
        callback(value)
      end
    else
      up_break = true
    end

    if cursor_row + count < botline then
      local match = matches[cursor_row + count - topline + 2]
      for _, value in ipairs(match) do
        callback(value)
      end
    else
      down_break = true
    end

    count = count + 1
  end
end

--- @param config Eye.Word.Config
function M.gaze(config)
  local win = vim.api.nvim_get_current_win()
  local wininfo = vim.fn.getwininfo(win)[1]
  local regex = require("eye.regex"):new({
    regex = config.regex,
    buf = vim.api.nvim_get_current_buf(),
    topline = wininfo.topline,
    botline = wininfo.botline,
    leftcol = wininfo.leftcol,
    rightcol = wininfo.leftcol + wininfo.width - wininfo.textoff,
  })
  local labels = {}

  iter(win, regex.matches, wininfo.topline, wininfo.botline, function(match)
    local col
    if config.position == -1 then
      col = match.start_col
    elseif config.position == 1 then
      col = match.end_col - 1
    end
    ---@type Eye.LabelSpec
    local label = {
      items = { { row = match.row - 1, col = col } },
    }
    table.insert(labels, label)
  end)

  require("eye.core")
    .gaze({
      label = {
        highlight = {
          show_next_key = false,
        },
      },
      matched = config.matched,
      source = {
        {
          buf = vim.api.nvim_get_current_buf(),
          source = labels,
        },
      },
    })
    :start()
end

return M
