local M = {}

local Key = require("magic.key")
local Line_hl = require("magic.line-hl")

local function get_col(position, line, wininfo, blank)
  local leftcol = wininfo.leftcol
  local rightcol = leftcol + wininfo.width - wininfo.textoff
  local width = wininfo.width - wininfo.textoff

  local col
  local cursor_col

  if position == 1 then
    local l = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""

    if #l == 0 then
      col = 0 - leftcol + 1
      cursor_col = 0
    else
      if not blank then
        col = l:find("%S") - 1 - leftcol
      else
        col = 0 - leftcol
      end
      cursor_col = l:find("%S") - 1
    end
  elseif position == 2 then
    local l = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
    if not blank then
      l = l:gsub("%s*$", "")
    end

    local displaywidth = vim.fn.strdisplaywidth(l)
    if #l == 0 then
      col = 0 - leftcol
      cursor_col = 0
    else
      if displaywidth > rightcol then
        col = width - 1
      else
        col = displaywidth - leftcol - 1
      end
      cursor_col = #l - 1
    end
  end

  return col, cursor_col
end

--- @class MagicLineStartEndOpts
--- @field position 1|2
--- @field callback fun(opts)
--- @field blank boolean

--- @param opts MagicLineStartEndOpts
function M.magic_line_start_end(opts)
  opts = opts or {}
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  local key = Key:init()
  Line_hl:init(topline, botline)
  key.compute(botline - topline + 1)

  for line = topline, botline do
    local col, cursor_col = get_col(opts.position, line, wininfo, opts.blank)
    key.register({
      callback = function()
        opts.callback({
          line = line,
          col = cursor_col,
        })
      end,
      one_key = {
        line = line - 1,
        virt_col = col,
      },
      two_key = {
        line = line - 1,
        virt_col = col,
        hidden_second_key = true,
      },
    })
  end
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
