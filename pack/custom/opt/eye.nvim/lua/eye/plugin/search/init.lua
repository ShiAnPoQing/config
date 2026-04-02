local U = require("eye.core.util")
local HL = require("eye.highlight")
local State = require("eye.plugin.search.state")
--- @class Eye.Plugin.Search
local M = {}

--- @class Eye.Plugin.Search.Config
--- @field matched? fun(ctx: Eye.Hook.Context)
--- @field unmatched? fun(ctx: Eye.Hook.Context)

local function get_next_pattern(key, pattern)
  local next_pattern
  if key == "<bs>" then
    next_pattern = vim.fn.strcharpart(pattern, 0, vim.fn.strcharlen(pattern) - 1)
  elseif key == "<cr>" then
    next_pattern = pattern
  else
    local label = key == "<space>" and " " or key
    next_pattern = pattern .. label
  end
  return next_pattern
end

--- @param matches table<Eye.Regex.Match>
local function iter_match(win, matches, topline, botline, callback)
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

local function notify(msg)
  vim.api.nvim_echo({
    { " 󰈈 ", "EyeSearchIcon" },
    { msg, "WarningMsg" },
  }, false, {})
end

local function rollback_state(pattern)
  local state = State:query(pattern)
  if state and state.Eye then
    state.Eye:start()
    return true
  end
end

--- @param buf integer
--- @param match Eye.Regex.Match
--- @param pattern string
--- @return string
local function get_exclude_char(buf, match, pattern)
  local text = vim.api.nvim_buf_get_text(buf, match.row - 1, match.start_col, match.row - 1, match.end_col, {})[1]
  local exclude_char
  if #text > #pattern then
    exclude_char = vim.fn.strcharpart(text, vim.fn.strcharlen(text) - 1, 1)
  end
  return exclude_char
end

--- @param buf integer
--- @param match Eye.Regex.Match
--- @param pattern string
--- @return Eye.Label.Spec, string
local function create_label(buf, match, pattern)
  local exclude_char = get_exclude_char(buf, match, pattern)
  local offset = exclude_char and #exclude_char or 0
  ---@type Eye.Label.Spec
  local label = {
    buf = buf,
    items = {
      {
        pos = { match.row - 1, match.end_col - offset },
      },
    },
    highlight = {
      HighlightPre = function(ns_id)
        vim.api.nvim_buf_set_extmark(buf, ns_id, match.row - 1, match.start_col, {
          end_col = match.end_col - offset,
          hl_group = "Visual",
        })
      end,
    },
    data = vim.tbl_deep_extend("force", match, {
      end_col = match.end_col - offset - 1,
    }),
  }
  return label, exclude_char
end

--- @param pattern string
--- @return Eye.Label.Spec[], string[], integer
local function create_labels(pattern)
  local buf = vim.api.nvim_get_current_buf()
  local labels = {}
  if pattern == "" then
    return labels, {}, buf
  end
  local win = vim.api.nvim_get_current_win()
  local wininfo = vim.fn.getwininfo(win)[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local rightcol = leftcol + wininfo.width - wininfo.textoff
  local regex = require("eye.regex"):new(pattern:gsub("([\\^$.~[*?+])", "\\%1") .. ".\\?")
  regex:match({
    {
      buf = buf,
      topline = topline,
      botline = botline,
      leftcol = leftcol,
      rightcol = rightcol,
    },
  })
  local exclude = {}
  iter_match(0, regex.matches, topline, botline, function(match)
    local label, exclude_char = create_label(buf, match, pattern)
    table.insert(labels, label)
    table.insert(exclude, exclude_char)
  end)

  return labels, exclude, buf
end

--- @param config Eye.Plugin.Search.Config
function M.gaze(config)
  config = config or {}
  State:init()
  local function step(pattern)
    if rollback_state(pattern) then
      return
    end
    local labels, exclude, buf = create_labels(pattern)
    local Eye = require("eye.core").gaze({
      labels = labels,
      label = {
        exclude = exclude,
      },
      layers = {
        {
          buf = buf,
          range = function(ctx)
            return { ctx.topline - 1, ctx.botline }
          end,
        },
      },
      finish = function(ctx)
        if ctx.completed then
          U.try(config.matched, ctx)
          return
        end
        if ctx.char:lower() == "<esc>" then
          U.try(config.unmatched, ctx)
          return
        end
        step(get_next_pattern(ctx.char:lower(), pattern))
      end,
    })
    State:register(pattern, Eye)
    Eye:start()
  end

  step("")
end

function M.setup()
  HL.register_highlights({
    {
      name = "EyeSearchIcon",
      value = {
        fg = "#ff007c",
        bold = true,
      },
    },
  })
end

return M
