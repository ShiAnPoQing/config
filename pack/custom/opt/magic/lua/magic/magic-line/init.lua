local M = {}
local Key = require("magic.key")
local Line_hl = require("magic.line-hl")

--- @class MagicLineOpts
--- @field dir "up" | "down" | "all"
--- @field callback fun()
function M.magic_line(opts)
  local dir = opts.dir
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  local cursor = vim.api.nvim_win_get_cursor(0)
  local virt_col = vim.fn.virtcol(".") - 1
  local startline, endline

  if dir == "up" then
    startline = topline
    endline = cursor[1] - 1
  elseif dir == "down" then
    startline = cursor[1] + 1
    endline = botline
  elseif dir == "all" then
    startline = topline
    endline = botline
  end

  Line_hl:init(startline, endline)
  local key = Key:init()
  key.compute(endline - startline + 1)
  for line = startline, endline do
    key.register({
      callback = function()
        opts.callback({
          line = line,
          virt_col = virt_col,
        })
      end,
      one_key = {
        line = line - 1,
        virt_col = virt_col,
      },
      two_key = {
        line = line - 1,
        virt_col = virt_col,
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
