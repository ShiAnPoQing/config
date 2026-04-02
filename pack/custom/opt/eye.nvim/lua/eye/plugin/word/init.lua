local Regex = require("eye.regex")

--- @class Eye.Word
local M = {}

--- @class Eye.Plugin.Word.RegexContext
--- @field word.inner string
--- @field word.outer string
--- @field WORD.inner string
--- @field WORD.outer string

--- @class Eye.Plugin.Word.Range
--- @field topline integer
--- @field botline integer

--- @class Eye.Plugin.Word.Config
--- @field regex string|fun(ctx: Eye.Plugin.Word.RegexContext): string
--- @field matched fun(ctx: Eye.Hook.Context)
--- @field unmatched? fun(ctx: Eye.Hook.Context)
--- @field position -1 | 0 | 1
--- @field hl_group? string
--- @field range? [integer, integer]|fun(range: Eye.Plugin.Word.Range): [integer, integer]

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

local function hl_word(hl_group, match, buf, ns_id)
  if type(hl_group) == "string" then
    vim.api.nvim_buf_set_extmark(buf, ns_id, match.row - 1, match.start_col, {
      end_col = match.end_col,
      hl_group = hl_group,
    })
  end
end

local function get_col(position, match)
  if position == -1 then
    return match.start_col
  end
  if position == 1 then
    return match.end_col - 1
  end
  if position == 0 then
    return math.floor((match.end_col - 1 - match.start_col) / 2) + match.start_col
  end
  return match.start_col
end

local function get_range(range, topline, botline)
  if type(range) == "function" then
    return range({
      topline = topline,
      botline = botline,
    })
  end
  if type(range) == "table" then
    return range
  end
  return { topline, botline }
end

local function get_matches(regex, buf, range, wininfo)
  local r = Regex:new(regex)
  r:match({
    {
      buf = buf,
      topline = range[1],
      botline = range[2],
      leftcol = wininfo.leftcol,
      rightcol = wininfo.leftcol + wininfo.width - wininfo.textoff,
    },
  })
  return r.matches
end

--- @param config Eye.Plugin.Word.Config
function M.gaze(config)
  config = vim.tbl_deep_extend("force", {}, config or {})
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local wininfo = vim.fn.getwininfo(win)[1]
  local range = get_range(config.range, wininfo.topline, wininfo.botline)
  --- @type Eye.Label.Spec[]
  local labels = {}
  iter(win, get_matches(config.regex, buf, range, wininfo), range[1], range[2], function(match)
    local col = get_col(config.position, match)
    ---@type Eye.Label.Spec
    local label = {
      buf = buf,
      items = {
        {
          pos = { match.row - 1, col },
        },
      },
      highlight = {
        HighlightPre = function(ns_id)
          hl_word(config.hl_group, match, buf, ns_id)
        end,
      },
      data = vim.tbl_deep_extend("force", {
        buf = buf,
        win = win,
      }, match),
    }
    labels[#labels + 1] = label
  end)

  require("eye.core")
    .gaze({
      labels = labels,
      label = {
        matched = config.matched,
      },
      layers = {
        buf = buf,
        range = range,
      },
      cancelled = function(ctx)
        if type(config.unmatched) == "function" then
          config.unmatched(ctx)
        end
      end,
    })
    :start()
end

return M
