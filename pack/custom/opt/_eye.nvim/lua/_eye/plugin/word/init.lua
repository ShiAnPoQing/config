local Regex = require("_eye.plugin.word.regex")

--- @class Eye.Word
local M = {}

--- @class _Eye.Plugin.Word.RegexContext
--- @field word.inner string
--- @field word.outer string
--- @field WORD.inner string
--- @field WORD.outer string

--- @class _Eye.Plugin.Word.Range
--- @field topline integer
--- @field botline integer

--- @class _Eye.Plugin.Word.Config
--- @field regex string|fun(ctx: Eye.Plugin.Word.RegexContext): string
--- @field matched fun(ctx: Eye.Hook.Context)
--- @field position -1 | 0 | 1
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
      should_capture = true,
    },
  })
  return r.matches
end

--- @param config _Eye.Plugin.Word.Config
function M.eye(config)
  config = vim.tbl_deep_extend("force", {}, config or {})
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local wininfo = vim.fn.getwininfo(win)[1]
  local range = get_range(config.range, wininfo.topline, wininfo.botline)
  local labels = {}
  iter(win, get_matches(config.regex, buf, range, wininfo), range[1], range[2], function(match)
    local col = get_col(config.position, match)
    local label = {
      buf = buf,
      row = match.row,
      col = col,
      win = win,
      match = match,
    }
    if config.position == 1 then
      local char = vim.fn.strcharpart(match.capture, vim.fn.strcharlen(match.capture) - 1, 1)
      if #char > 1 then
        label.show = false
        label.col = label.col - #char
      end
    end

    labels[#labels + 1] = label
  end)

  local H = require("_eye.core.highlight")
  local eye = require("_eye.core"):new(labels, {})
  eye:_active({
    active = function(ctx)
      if #ctx.entries > 0 then
        local hls = {}
        for _, entry in ipairs(ctx.entries) do
          local text = vim.fn.join(entry.labels, "")
          if entry.data then
            table.insert(hls, {
              buf = entry.data.buf,
              row = entry.data.row - 1,
              col = entry.data.col,
              virt_text = { { text:sub(1, 1), H.EyeLabel } },
            })
          end
          table.insert(hls, {
            buf = entry.data.buf,
            row = entry.data.row - 1,
            col = entry.data.col + 1,
            virt_text = { { text:sub(2), H.EyeNextLabel } },
          })
        end
        local clean = H.highlight(hls, {})
        return function()
          clean()
        end
      else
        ctx.rollback(1)
      end
    end,
    actions = {
      ["<bs>"] = function(ctx)
        ctx.rollback(1)
      end,
    },
  })
end

return M
